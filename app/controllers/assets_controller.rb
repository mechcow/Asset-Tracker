require 'LdapDns'
require 'ldap'
require 'rubygems'
require 'fastercsv'

class AssetsController < ApplicationController
  managed_resource Asset
  before_filter :load_asset_class
  before_filter :load_asset, :except => [:index,:new, :generate_csv, :dns, :live_search]

  permit "site_admin", :except => [:index,:show]


  autocomplete_for :tag, :name do |tags|
    Asset.tags_like(params[:term]).map(&:capitalize).to_json if params.has_key? :term
  end 

  def generate_csv
    @physical_assets = PhysicalMachine.all
    @guest_assets = VirtualMachine.all

    res = FasterCSV.generate do |csv|
      csv << [ "Physical Assets" ]
      csv << [ "FQDN", "Manufacturer", "Model", "Serial", "Type", "CPU", "RAM (MB)", "Total Disk Space", "Disk Types", "Location"  ]

      @physical_assets.each do |asset|
        csv << [asset.fqdn, 
                asset.model.manufacturer.name, 
                asset.model.name, 
                asset.serial, 
                asset.type,
                asset.cpu,
                asset.ram,
                asset.disk_space,
                asset.disk_type,
                asset.location.name,
               ]
      end

      csv << [ "" ]
      csv << [ "Xen Guests" ]
      csv << [ "FQDN", "Parent", "VCPU", "RAM (MB)", "Location", "Roles"  ]

      @guest_assets.each do |asset|
        csv << [asset.fqdn,
                asset.parent.shortname,
                asset.vcpus,
                asset.ram,
                asset.location.name,
                asset.roles.map { |role| role.name }.join(", ")  ]
      end
      
    end
  end

  # GET /assets
  # GET /assets.xml
  def index
    @assets = Asset.filter(load_filters).all(:include => {:inventoriable => {:asset => [:user,:location,{:model=>[:manufacturer, :kind]}]}}).sort.map(&:inventoriable)

    # @assets = Asset.filter(load_filters).all( :include => [:location,:interfaces, :user, {:model => [:manufacturer, :kind]}], 
    #                                           :order => 'users.login ASC, manufacturers.name ASC')

    #TODO workaround during transition, remove when migration has finished
    if request.format.puppet?
      @physical_assets = PhysicalMachine.all(:include => [:interfaces,:roles,{:asset => [:user,:location,{:model=>[:manufacturer, :kind]}]}])
      @guest_assets = VirtualMachine.all(:include => [:interfaces,:roles,{:asset => [:user,:location,{:model=>[:manufacturer, :kind]}]}])
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.puppet
      format.xml  { render :xml => @assets.to_xml(:include => :asset) }
      format.csv { send_data self.generate_csv,
                             :type => "text/csv; charset=iso-8859-1; header=present",
                             :disposition => "attachment; filename=assets.csv"
                 }
    end
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    respond_to do |format|
      format.html {render :template =>"#{@asset.underscore_inventoriable_type}/show" }
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.xml
  def new
    @asset = @asset_class.new_with_asset

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    render :template =>"#{@asset.underscore_inventoriable_type}/edit"
  end

  # POST /assets
  # POST /assets.xml
  def create
    @asset       = @asset_class.new(params[@asset_class.to_s.underscore])

    respond_to do |format|
      if @asset.valid? and @asset.save
        flash[:notice] = 'Asset was successfully created.'
        #TODO: re-enable
        #Notifications.deliver_assigned(@asset)
        format.html { redirect_to(edit_polymorphic_path(@asset)) }
        format.xml  { render :xml => @asset, :status => :created, :location => @asset }
        format.js   { render :template => 'assets/create', :layout => false}
      else
        format.html { render :template =>"#{@asset.underscore_inventoriable_type}/edit" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
        format.js   { render :template => 'assets/create', :layout => false}
      end
    end
  end


  # PUT /assets/1
  # PUT /assets/1.xml
  def update
    respond_to do |format|
      # if !params[:interface]["name"].blank?
      #   @interface = Interface.new(params[:interface])
      #   if @interface.valid? and @interface.save
      #     p "interface save succeeded"
      #     @asset.interfaces << @interface
      #     @asset.save
      #     # add to DNS only if its a VPN interface
      #     if @interface.tags.include?("vpn")
      #       session[:fqdn] = @asset.fqdn
      #       session[:ipaddr] = @interface.ipaddr
      #       format.html { render :action => "dns" }
      #       #LdapDns.add_a_record(current_user.conn,@asset.fqdn,@interface.ipaddr)
      #       #LdapDns.add_reverse_record(current_user.conn,@asset.fqdn,@interface.ipaddr)
      #     end
      #   else
      #     p "interface save failed"
      #     p @interface.errors
      #     format.html { render :template =>"#{@asset.asset.inventoriable_type.pluralize.downcase}/edit" }
      #     format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      #     format.js
      #   end
      # end
      
      if (params[@asset_class.to_s.underscore].has_key?:new_interface_attributes) &&
          (params[@asset_class.to_s.underscore][:new_interface_attributes][0][:name].blank?)
        params[@asset_class.to_s.underscore].delete(:new_interface_attributes)
      end

      if @asset.update_attributes(params[@asset_class.to_s.underscore])
        flash[:notice] = 'Asset was successfully updated.'
        # TODO: re-enable these
        #Notifications.deliver_assigned(@asset)
        format.html { redirect_to(edit_polymorphic_path(@asset)) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :template =>"#{@asset.underscore_inventoriable_type}/edit" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    @id = params[:id]
    @asset.destroy
    # Notifications.deliver_unassigned(@asset)
    respond_to do |format|
      format.html { redirect_to(assets_url) }
      format.xml  { head :ok }
      format.js   {render :template => 'assets/destroy',:layout => false}
    end
  end

  # CLONE /assets/1
  # CLONE /assets/1.xml
  def deep_clone
    
    @asset_old  = @asset
    @asset      = @asset_old.clone_with_associations

    respond_to do |format|
      # if errors.empty?
      #   format.html { render :controller=> :assets, :action => :edit }
      # else
      #   # shouldn't ever be possible to get here normally
      #   p "ERROR: could not clone asset %s" % @asset.fqdn
      #   errors.each { |e| p e.to_yaml }
      #   format.html { redirect_to(assets_url) }
      # end
      format.html { render :template =>"#{@asset.underscore_inventoriable_type}/edit" }
    end
  end

  # DNS /assets/1
  # DNS /assets/1.xml
  def dns
    @asset = Asset.find(params[:id])

    Ldap['ldaphost'].each do |ldaphost|
      puts ldaphost
      puts Ldap['binddn'] % current_user.login
      conn = LdapDns.connect_ldap(ldaphost,389,Ldap['binddn'] % current_user.login,params[:password])
      LdapDns.add_a_record(conn,session[:fqdn],session[:ipaddr])
      LdapDns.add_reverse_record(conn,session[:fqdn],session[:ipaddr])
      break
    end
    
    flash[:notice] = 'DNS Updated'
    # TODO: re-enable these
    #Notifications.deliver_assigned(@asset)
    respond_to do |format|
      format.html { redirect_to(edit_asset_path(@asset)) }
    end
  end

  
  
  def live_search
    search_phrase = params[:searching]
    @assets = Asset.named(search_phrase).all(:include => {:inventoriable => {:asset => [:user,:location,{:model=>[:manufacturer, :kind]}]}}).sort.map(&:inventoriable)
    logger.debug "search_phrase: %s" % search_phrase
    logger.debug "assets: %s" % @assets.join(",")
    render(:layout => false)
  end

  def tags
    @assets = Asset.all(:include=> :tags)
    respond_to do |format|
      format.yaml {render :layout=>false}
    end
  end

  private

  def load_asset_class
    @asset_class = params[:controller].classify.constantize
  end

  def load_asset
    @asset       = @asset_class.find(params[:id],:include=>{:asset => [:user,:location,{:model=>[:manufacturer, :kind]}] }) if params[:id]
  end

end

class InterfacesController < ApplicationController
  permit "site_admin", :except => [:index,:show]

  autocomplete_for :tag, :name do |tags|
    Interface.tags_like(params[:term]).map(&:capitalize).to_json if params.has_key? :term
  end

  autocomplete_for :interface, :ip do |interfaces|
    Interface.free_ips_like(params[:term]).to_json if params.has_key? :term
  end

  def test_if_used
    ipaddr = params[:test_if_used]
    @ip_in_use = (Interface.find(:first, :conditions => {:ipaddr => ipaddr}) or Vip.find(:first, :conditions => {:ipaddr => ipaddr}))
    respond_to do |format|
      format.js { render :action => :ip_in_use, :layout => false }
    end
  end

  # GET /interfaces
  # GET /interfaces.xml
  def index
    @interfaces = Interface.all
    @interface = Interface.new
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interfaces }
      format.js { render :layout => false } # index.js.erb
      format.json { render :json => @ip_addresses, :layout => false }
    end
  end

  # GET /interfaces/1
  # GET /interfaces/1.xml
  def show
    @interface = Interface.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interface }
    end
  end

  # GET /interfaces/new
  # GET /interfaces/new.xml
  def new
    @interface = Interface.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interface }
    end
  end

  # GET /interfaces/1/edit
  def edit
    @interface = Interface.find(params[:id])
  end

  # POST /interfaces
  # POST /interfaces.xml
  def create
    @interface = Interface.new(params[:interface])

    respond_to do |format|
      if @interface.save
        flash[:notice] = 'Interface was successfully created.'
        format.html { redirect_to(interfaces_path) }
        format.xml  { render :xml => @interface, :status => :created, :location => @interface }
        format.js
      else
        format.html { render :action => :index }
        format.xml  { render :xml => @interface.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end


  # PUT /interfaces/1
  # PUT /interfaces/1.xml
  def update
    @interface = Interface.find(params[:id])

    respond_to do |format|
      if @interface.update_attributes(params[:interface])
        flash[:notice] = 'Interface was successfully updated.'
        format.html { redirect_to(edit_polymorphic_path(@interface.machine)) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interface.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /interfaces/1
  # DELETE /interfaces/1.xml
  def destroy
    @id = params[:id]
    @interface = Interface.find(@id)
    @interface.destroy

    respond_to do |format|
      format.html { redirect_to(interfaces_url) }
      format.xml  { head :ok }
      format.js
    end
  end
  
end

class RolesController < ApplicationController
  permit "site_admin", :except => [:index,:show]

  before_filter :load_asset

  # GET /roles
  # GET /roles.xml
  def index
    @roles = roles.all

    @role = Role.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = Role.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        flash[:notice] = 'Role was successfully created.'
        format.html { redirect_to(roles_path) }
        format.xml  { render :xml => @role, :status => :created, :location => @role }
        format.js
      else
        format.html { render :action => :index }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end


  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        flash[:notice] = 'Role was successfully updated.'
        format.html { redirect_to(roles_path) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @id = params[:id]
    @role = Role.find(@id)
    @role.destroy

    respond_to do |format|
      format.html { redirect_to(roles_url) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def load_asset
    @asset = Asset.find(params[:asset_id]) if params[:asset_id]
  end  

  def roles
    @asset ? @asset.role : Role
  end

end

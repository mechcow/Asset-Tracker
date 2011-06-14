class VirtualMachinesController < AssetsController
  # GET /assets/1/parent.xml
  def parent
    @asset  = VirtualMachine.find(params[:id])
    @parent = @asset.parent
    respond_to do |wants|
      if @parent
        wants.xml { render :xml => @parent }
      else 
        wants.xml { render :nothing => true, :status => 404 }
      end 
    end 
  end 
end

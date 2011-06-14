class PhysicalMachinesController < AssetsController
  #Some special routes for the CLI
  # GET /physical_machine/1/guests.xml
  def guests
    @asset  = PhysicalMachine.find(params[:id])
    @guests = @asset.guests
    respond_to do |wants|
      if @guests.any?
        wants.xml { render :xml => @guests}
      else 
        wants.xml { render :nothing => true, :status => 404 }
      end
    end 
  end 
end

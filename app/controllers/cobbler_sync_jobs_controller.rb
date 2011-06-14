class CobblerSyncJobsController < ApplicationController
  
  def index
    @jobs = Delayed::Job.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def create
    provisioning_servers = Machine.tagged(PROVISIONING_SERVER_TAG)

    #Add error handling
    provisioning_servers.each do |machine|
      Delayed::Job.enqueue(CobblerWorker.new(machine.id))
    end
    respond_to do |format|
      flash[:notice] = "#{provisioning_servers.size} job(s) was/were successfully created."
      format.html { redirect_to(cobbler_sync_jobs_path) }
    end
  end


end

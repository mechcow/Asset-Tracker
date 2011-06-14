module CobblerSyncJobsHelper
  def job_name(job)
    job.handler.match(/machine_id:\s*(\d*)/)
    Machine.find($1).name
  end
end

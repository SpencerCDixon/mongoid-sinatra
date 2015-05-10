require 'json'

class SyncJobStarter
  def initialize(type, id)
    @syncable_type, @syncable_id = type, id
  end

  def start
    sj = SyncJob.find_by(job_id: @syncable_id, sync_type: @syncable_type)
    if sj
      { error: 'Job already started' }.to_json
    else
      SyncJob.create(start_time: Time.now, job_id: @syncable_id, sync_type: @syncable_type)
      { success: 'Created a new SyncJob' }.to_json
    end
  end

  def current_status
    sj = SyncJob.find_by(job_id: @id, sync_type: @type)

    if sj
      { job_id: @id, sync_type: @type, status: sj[:job_status] }.to_json
    else
      { error: 'No jobs started' }.to_json
    end
  end
end

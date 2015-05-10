require 'mongoid'

class SyncJob
  include Mongoid::Document

  field :start_time,   type: String
  field :job_id, type: String
  field :sync_type, type: String
  field :job_status, type: String
end

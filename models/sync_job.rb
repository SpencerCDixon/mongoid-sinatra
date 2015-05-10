require 'mongoid'

class SyncJob
  include Mongoid::Document

  field :start_time,   type: String
  field :job_id, type: String
end

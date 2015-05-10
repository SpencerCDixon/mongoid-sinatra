require_relative '../spec_helper'
require_relative '../../models/sync_job'
require_relative '../../models/sync_job_starter'
require 'pry'

describe SyncJobStarter do
  describe "#current_status" do
    context "Sync Job exists" do
      it "finds it" do
        sync_job = SyncJob.create(start_time: Time.now, job_id: 5, sync_type: 'practice', job_status: 'working')
        starter = SyncJobStarter.new(sync_job[:sync_type], sync_job[:job_id])
        expect(starter.current_status).to eq ({ job_id: '5', sync_type: 'practice', status: 'working' }.to_json)
      end
    end

    context "Sync Job doesn't exist" do
      it 'doesnt find it' do
        starter = SyncJobStarter.new(1, 2)
        expect(starter.current_status).to eq ({ error: 'No jobs started' }.to_json)
      end
    end
  end
end

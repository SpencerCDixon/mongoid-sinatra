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

  describe "#start" do
    context "no job has been started" do
      it "starts a new job" do
        expect(FullSyncWorker.jobs.size).to eq 0
        SyncJobStarter.new('practice', 100).start
        expect(FullSyncWorker.jobs.size).to eq 1
      end

      it "creates a new Sync Job associated to the Sidekiq job" do
        expect(SyncJobStarter.new('practice', 100).start).to eq(
          { success: 'Created a new SyncJob',
            sidekiq_jid: FullSyncWorker.jobs.last["jid"],
            sync_id: "100",
            sync_type: 'practice'
            }.to_json
        )
      end
    end
  end
end

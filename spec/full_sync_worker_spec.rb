require_relative '../server.rb' # where my worker lives
require 'spec_helper' # sets up sidekiq configs

describe FullSyncWorker do
  it "adds job to the queue" do
    expect {
      FullSyncWorker.perform_async("Some message")
    }.to change(FullSyncWorker.jobs, :size).by(1)
  end
end

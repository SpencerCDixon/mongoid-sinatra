require 'sinatra'
require 'mongoid'
require 'sidekiq'
require 'sidekiq/api'
require 'redis'
require 'pry'

Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

configure do
  Mongoid.load!("./mongoid.yml")
end

$redis = Redis.new

class FullSyncWorker
  include Sidekiq::Worker

  def perform(msg)
    $redis.lpush('example-messages', msg)
  end
end

get '/' do
  stats = Sidekiq::Stats.new # built into the sidekiq/api
  @failed = stats.failed
  @processed = stats.processed
  @messages = $redis.lrange('example-messages', 0, -1)
  erb :home
end

get '/api/v1/practices/:practice_id/sync' do |practice_id|
  content_type :json
  SyncJobStarter.new('practice', practice_id).start
  # FullSyncWorker.perform_async('message')
end

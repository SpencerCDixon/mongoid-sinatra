require 'sinatra'
require 'mongoid'
require 'pry'

Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }

configure do
  Mongoid.load!("./mongoid.yml")
end

before do
  content_type :json
end

get '/api/v1/practices/:practice_id/sync' do |practice_id|
  SyncJobStarter.new('practice', practice_id).start
end

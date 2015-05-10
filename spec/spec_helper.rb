require 'rspec'
require 'rack/test'
require 'sidekiq/testing'
require 'pry'
require File.expand_path '../../server.rb', __FILE__

ENV['RACK_ENV'] = 'test'

Mongoid.load!("mongoid.yml", :test)
Sidekiq::Testing.fake!

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.color = true

  # DB Cleaner for Mongoid tests
  config.before do
    Mongoid.purge!
  end

  # Clear all sidekiq workers before tests
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end

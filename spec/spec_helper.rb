require 'rspec'
require 'rack/test'
require 'pry'
require File.expand_path '../../server.rb', __FILE__

ENV['RACK_ENV'] = 'test'

Mongoid.load!("mongoid.yml", :test)

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
end

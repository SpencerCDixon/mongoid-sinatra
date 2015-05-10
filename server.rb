require 'sinatra'
require 'sinatra/reloader' if development?
require 'mongoid'

configure do
  Mongoid.load!("./mongoid.yml")
end

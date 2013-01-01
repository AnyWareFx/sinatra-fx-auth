require 'sinatra/base'
require 'sinatra/fx-auth'
require 'rack/test'

require 'fx-auth/models'
require './test/factories'


module Test
  class App < Sinatra::Base
    register Sinatra::Fx::Auth
  end
end


module AppHelper
  def app
    Test::App
  end
end


World(Rack::Test::Methods, AppHelper)

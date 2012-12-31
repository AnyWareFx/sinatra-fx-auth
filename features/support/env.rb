require 'rack/test'
require 'fx-auth/models'
require 'sinatra/fx-auth'


module AppHelper
  def app
    Sinatra::Application
  end
end


World(Rack::Test::Methods, AppHelper)

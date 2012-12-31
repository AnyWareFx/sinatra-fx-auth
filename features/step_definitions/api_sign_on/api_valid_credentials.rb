
When /^the App signs me on with valid credentials$/ do
  credentials = {
      :profile => {
          :email => @user.email,
          :pass_phrase => "password"
      }
  }
  @client = Rack::Test::Session.new Rack::MockSession.new AuthFx::App
  @client.post '/profiles/' + @user.id.to_s + '/key', credentials
end
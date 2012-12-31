
When /^the App signs me off$/ do
  @client = Rack::Test::Session.new Rack::MockSession.new AuthFx::App
  @client.header 'X-AUTH-TOKEN', @user.pass_key.token
  @client.delete '/profiles/' + @user.id.to_s + '/key'
  @user.reload  # Refresh from the database
end
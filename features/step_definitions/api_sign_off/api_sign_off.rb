
When /^the App signs me off$/ do
  @client = Rack::Test::Session.new Rack::MockSession.new Test::App
  @client.header 'X-AUTH-TOKEN', @user.pass_key.token
  @client.delete '/profiles/' + @user.id.to_s + '/key'
  @user.reload  # Refresh from the database
end


Then /^I am offline$/ do
  @user.status.should == :offline
end


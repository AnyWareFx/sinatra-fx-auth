
When /^the App tries to sign me on with invalid credentials$/ do
  credentials = {
      :profile => {
          :email => "bad@email.com",
          :pass_phrase => "bad-password"
      }
  }
  @client = Rack::Test::Session.new Rack::MockSession.new Test::App
  @client.post '/profiles/' + @user.id.to_s + '/key', credentials
end


When /^the App receives an Invalid User error$/ do
  received = JSON.parse @client.last_response.body
  expected = JSON.parse({:error => "The email or pass phrase you provided doesn't match our records."}.to_json)
  received.should == expected
end
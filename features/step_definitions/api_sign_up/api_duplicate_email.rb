
When /^the App tries to sign me up with a duplicate email$/ do
  email = FactoryGirl.generate :email
  @user = AuthFx::UserProfile.sign_up email, "password", '127.0.0.1'
  credentials = {
      :profile => {
          :email => email,
          :pass_phrase => "password"
      }
  }
  @client = Rack::Test::Session.new Rack::MockSession.new AuthFx::App
  @client.post '/profiles/', credentials
end


Then /^the App receives a duplicate email error$/ do
  received = JSON.parse @client.last_response.body
  expected = JSON.parse({:error => "We already have that email."}.to_json)
  received.should == expected
end
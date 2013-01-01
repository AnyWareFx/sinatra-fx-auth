
When /^the App tries to sign me up with a duplicate email$/ do
  email = FactoryGirl.generate :email
  @user = AuthFx::UserProfile.sign_up email, "password"
  credentials = {
      :profile => {
          :email => email,
          :pass_phrase => "password"
      }
  }
  @client = Rack::Test::Session.new Rack::MockSession.new Test::App
  @client.post '/profiles/', credentials
end


Then /^the App receives a duplicate email error$/ do
  received = JSON.parse @client.last_response.body
  expected = JSON.parse({:error => "We already have that email."}.to_json)
  received.should == expected
end
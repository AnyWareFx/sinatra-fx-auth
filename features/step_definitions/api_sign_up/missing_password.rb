
When /^the App tries to sign me up with a missing password$/ do
  email = FactoryGirl.generate :email
  credentials = {
      :profile => {
          :email => email,
          :pass_phrase => ""
      }
  }
  @client = Rack::Test::Session.new Rack::MockSession.new AuthFx::App
  @client.post '/profiles/', credentials
end


Then /^the App receives a missing password error$/ do
  received = JSON.parse @client.last_response.body
  expected = JSON.parse({:errors => {:pass_phrase => ["Pass phrase must be between 5 and 50 characters long"]}}.to_json)
  received.should == expected
end

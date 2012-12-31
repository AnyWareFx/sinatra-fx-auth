
When /^the App tries to sign me up with a missing email address$/ do
  credentials = {
      :profile => {
          :email => "",
          :pass_phrase => "password"
      }
  }
  @client = Rack::Test::Session.new Rack::MockSession.new AuthFx::App
  @client.post '/profiles/', credentials
end


Then /^the App receives a missing email error$/ do
  received = JSON.parse @client.last_response.body
  expected = JSON.parse({:errors => {:email => ["We need your email address."]}}.to_json)
  received.should == expected
end

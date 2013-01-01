
When /^the App tries to sign me up with an invalid email address$/ do
  credentials = {
      :profile => {
          :email => "bad.email.com",
          :pass_phrase => "password"
      }
  }
  @client = Rack::Test::Session.new Rack::MockSession.new Test::App
  @client.post '/profiles/', credentials
end


Then /^the App receive an invalid email error$/ do
  received = JSON.parse @client.last_response.body
  expected = JSON.parse({:errors => {:email => ["Doesn't look like an email address to me ..."]}}.to_json)
  received.should == expected
end
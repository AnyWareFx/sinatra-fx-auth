
When /^the App signs me up with valid credentials$/ do
  email = FactoryGirl.generate :email
  credentials = {
      :profile => {
          :email => email,
          :pass_phrase => "password"
      }
  }
  @client = Rack::Test::Session.new Rack::MockSession.new AuthFx::App
  @client.post '/profiles/', credentials
end


Then /^the App receives a (\d+) response code$/ do |arg|
  @client.last_response.status.should == arg.to_i
end


Then /^the App receives an Auth Token$/ do
  token = @client.last_response.headers['X-AUTH-TOKEN']
  token.should_not.nil?
end

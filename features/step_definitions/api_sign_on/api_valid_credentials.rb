
Given /^I have a User Profile$/ do
  @user = FactoryGirl.create :user_profile
  @user.save # TODO Determine why this is necessary
end


When /^the App signs me on with valid credentials$/ do
  credentials = {
      :profile => {
          :email => @user.email,
          :pass_phrase => "password"
      }
  }
  @client = Rack::Test::Session.new Rack::MockSession.new Test::App
  @client.post '/profiles/' + @user.id.to_s + '/key', credentials
end


When /^I sign on with valid credentials$/ do
  @user.sign_on @user.email, 'password'
end


When /^I am online$/ do
  @user.status.should == :online
end
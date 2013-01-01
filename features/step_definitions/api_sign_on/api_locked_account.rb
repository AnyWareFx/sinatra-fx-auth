
When /^the App receives a Locked User error$/ do
  received = JSON.parse @client.last_response.body
  expected = JSON.parse({:error => "Your account is locked. You can try to sign on again in 30 minutes."}.to_json)
  received.should == expected
end


Given /^I have a Locked User Profile$/ do
  @user = FactoryGirl.create :user_profile
  @user.status = :locked
  @user.save
end
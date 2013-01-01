require 'factory_girl'
require 'test/seeds'


FactoryGirl.define do

  sequence :email do |n|
    "profile#{n}@example.com"
  end


  factory :user_profile, :class => AuthFx::UserProfile do
    email
    pass_phrase "password"
  end

end

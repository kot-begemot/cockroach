require "factory_girl"

FactoryGirl.define do
  factory(:user) do
    sequence(:email) { |n| "user_number#{n}@test.com" }
    sequence(:first_name) { |n| "user_number#{n}" }
    sequence(:last_name) { |n| "user_number#{n}" }
  end
  
  factory(:user_admin, :parent => :user) do
    role :admin
  end
  
  factory(:user_other, :parent => :user) do
    role :other
  end
end


require "factory_girl"

FactoryGirl.define do
  factory(:user) do
    sequence(:email) { |n| "user_number#{n}@test.com" }
    sequence(:first_name) { |n| "user_number#{n}" }
    sequence(:last_name) { |n| "user_number#{n}" }

    factory :user_admin do
      role :admin
    end

    factory :user_other  do
      role :other
    end
  end
end


FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password 'welcome'
    password_confirmation 'welcome'
  end
end

FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password 'welcome4059'
    password_confirmation 'welcome4059'
  end
end

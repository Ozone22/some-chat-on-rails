FactoryGirl.define do

  factory :user do
    sequence(:login) { |n| "Michael#{n}" }
    sequence(:email) { |n| "michael#{n}@example.com" }
    password 'foobaR1'
    password_confirmation 'foobaR1'

    factory :admin do
      email_confirmed true
      admin true
    end

    factory :confirmed_user do
      email_confirmed true
    end
  end
end
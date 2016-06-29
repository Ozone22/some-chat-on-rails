FactoryGirl.define do

  factory :user do
    login 'Michael'
    email 'michael@example.com'
    password 'foobaR1'
    password_confirmation 'foobaR1'
    email_confirmed false
  end
end
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@email.com" }
    first_name { 'John' }
    last_name { 'Doe' }
  end
end

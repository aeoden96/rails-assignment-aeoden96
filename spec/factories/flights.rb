FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "Flight-#{n}" }
    no_of_seats { 2 }
    base_price { 150 }
    departs_at { DateTime.now + 1.day }
    arrives_at { DateTime.now + 2.days }

    company { create(:company) }
  end
end

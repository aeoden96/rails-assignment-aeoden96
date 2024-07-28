# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  no_of_seats :integer          not null
#  seat_price  :integer          not null
#  user_id     :bigint           not null
#  flight_id   :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :booking do
    no_of_seats { 2 }
    seat_price { 150 }

    user { create(:user) }
    flight { create(:flight) }
  end
end

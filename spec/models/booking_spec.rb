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
require 'rails_helper'

RSpec.describe Booking, type: :model do
  booking_params = { no_of_seats: 2, seat_price: 150 }
  let(:user) { User.create(first_name: 'Marko', email: 'marko@gmail.com') }
  let(:booking) { described_class.new(booking_params.merge(user: user, flight: flight)) }
  let(:past_booking) { described_class.new(booking_params.merge(user: user, flight: past_flight)) }
  let(:flight) { Flight.create(departs_at: DateTime.now + 1.day) }
  let(:past_flight) { Flight.create(departs_at: DateTime.now - 1.day) }

  describe 'validations' do
    it 'is valid' do
      expect(booking).to be_valid
    end

    it 'is not valid with a seat price <= 0' do
      booking.seat_price = 0
      expect(booking).not_to be_valid
    end

    it 'is not valid with a number of seats <= 0' do
      booking.no_of_seats = 0
      expect(booking).not_to be_valid
    end

    it 'is not valid if the flight is in the past' do
      expect(past_booking).not_to be_valid
      expect(past_booking.errors[:flight]).to include('must not be in the past')
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:flight) }
    it { is_expected.to belong_to(:user) }
  end
end

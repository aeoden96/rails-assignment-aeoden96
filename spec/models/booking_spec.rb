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
  let(:booking) { create(:booking) }

  # Creates a booking with a flight that has departed
  let(:past_booking) { build(:booking, flight: create(:flight, departs_at: DateTime.now - 1.day)) }

  describe 'validations' do
    it 'is valid' do
      expect(booking).to be_valid
    end

    it { is_expected.to validate_numericality_of(:seat_price).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:no_of_seats).is_greater_than(0) }

    it 'is not valid if the flight is in the past' do
      expect(past_booking).not_to be_valid
      expect(past_booking.errors[:flight]).to include('must not be in the past')
    end
  end

  describe 'checks if flight is overbooked' do
    let(:flight) { create(:flight, no_of_seats: 2) }

    context 'when updating flight' do
      it 'is not overbooked if valid' do
        booking = create(:booking, flight: flight, no_of_seats: 1)
        booking.update(no_of_seats: 2)
        expect(booking).to be_valid
      end

      it 'is overbooked if invalid' do
        booking = create(:booking, flight: flight, no_of_seats: 1)
        booking.update(no_of_seats: 3)
        expect(booking).not_to be_valid
        expect(booking.errors[:no_of_seats]).to include('exceeds available seats for this flight')
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:flight) }
    it { is_expected.to belong_to(:user) }
  end
end

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
class Booking < ApplicationRecord
  belongs_to :flight
  belongs_to :user

  validates :seat_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validate :flight_not_in_past
  validate :seats_available

  def flight_not_in_past
    return unless flight.present? && flight.departs_at.present?
    return if flight.departs_at > DateTime.current

    errors.add(:flight, 'must not be in the past')
  end

  def seats_available
    return if flight.blank?
    if flight.bookings.where.not(id: id).sum(:no_of_seats) + no_of_seats <= flight.no_of_seats
      return
    end

    errors.add(:no_of_seats, 'exceeds available seats for this flight')
  end

  scope :with_active_flights, lambda {
    joins(:flight).merge(Flight.upcoming).distinct
  }
end

# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  no_of_seats :integer
#  base_price  :integer          not null
#  departs_at  :datetime         not null
#  arrives_at  :datetime         not null
#  company_id  :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Flight < ApplicationRecord
  belongs_to :company

  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id }
  validates :departs_at, presence: true
  validates :arrives_at, presence: true
  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validates :no_of_seats, presence: true, numericality: { greater_than: 0 }
  validate :departs_at_before_arrives_at
  validate :no_overlapping_flights

  def departs_at_before_arrives_at
    return unless departs_at.present? && arrives_at.present?
    return if departs_at < arrives_at

    errors.add(:departs_at, 'must be before arrives_at')
  end

  scope :upcoming, lambda {
    where('departs_at > ?', Time.current)
  }

  scope :same_company, lambda { |company_id, id|
    where(company_id: company_id).where.not(id: id)
  }

  scope :not_overlapping, lambda { |flight|
    where('? BETWEEN departs_at AND arrives_at OR ? BETWEEN departs_at AND arrives_at',
          flight.departs_at, flight.arrives_at)
  }

  def no_overlapping_flights
    return unless company.present? && departs_at.present? && arrives_at.present?

    overlapping_flights = Flight.same_company(company_id, id).not_overlapping(self)

    return unless overlapping_flights.exists?

    errors.add(:departs_at, 'overlap with another flight in same company')
  end
end

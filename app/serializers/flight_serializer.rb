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
class FlightSerializer < Blueprinter::Base
  identifier :id

  fields :name, :base_price, :no_of_seats, :departs_at, :arrives_at, :created_at, :updated_at

  field :no_of_booked_seats do |flight|
    flight.bookings.sum(:no_of_seats)
  end

  field :company_name do |flight|
    flight.company.name
  end

  field :current_price do |flight|
    days_to_departure = (flight.departs_at.to_date - Time.zone.today).to_i

    if days_to_departure >= 15
      flight.base_price
    else
      multiplier = 1 + ((15 - days_to_departure) / 15.0)
      (flight.base_price * multiplier).round
    end
  end

  association :company, blueprint: CompanySerializer
end

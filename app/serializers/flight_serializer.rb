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
    departure_date = flight.departs_at.to_date
    booked_at = DateTime.current.to_date
    difference = (departure_date - booked_at).to_i

    if difference >= 15
      flight.base_price
    elsif difference < 15 && difference >= 0
      (flight.base_price * (1 + ((15 - difference).to_f / 15))).round
    else
      (flight.base_price * 2).round
    end
  end

  association :company, blueprint: CompanySerializer
end

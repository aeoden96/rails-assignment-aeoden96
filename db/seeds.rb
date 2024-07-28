# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create companies
company1 = Company.create!(name: 'Airways Inc.')
company2 = Company.create!(name: 'Skyline Airways')

# Create users
user1 = User.create!(first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com', password: 'password')
user2 = User.create!(first_name: 'Jane', last_name: 'Smith', email: 'jane.smith@example.com', password: 'password')

# Create flights
flight1 = Flight.create!(
  name: 'Flight 101',
  no_of_seats: 100,
  base_price: 299,
  departs_at: 1.day.from_now,
  arrives_at: 3.days.from_now,
  company: company1
)

flight2 = Flight.create!(
  name: 'Flight 202',
  no_of_seats: 150,
  base_price: 399,
  departs_at: 2.days.from_now,
  arrives_at: 4.days.from_now,
  company: company2
)

# Create bookings
Booking.create!(
  no_of_seats: 2,
  seat_price: 299,
  user: user1,
  flight: flight1
)

Booking.create!(
  no_of_seats: 1,
  seat_price: 399,
  user: user2,
  flight: flight2
)
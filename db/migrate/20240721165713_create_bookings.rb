class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|

      t.integer :no_of_seats, null: false
      t.decimal :seat_price, null: false
      t.belongs_to :user, null: false, foreign_key: true, index: true
      t.belongs_to :flight, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end

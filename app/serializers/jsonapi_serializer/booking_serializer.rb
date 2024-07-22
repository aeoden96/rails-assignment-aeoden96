module JsonapiSerializer
  class BookingSerializer
    include JSONAPI::Serializer

    attributes :no_of_seats, :seat_price, :created_at, :updated_at

    belongs_to :user, serializer: JsonapiSerializer::UserSerializer
    belongs_to :flight, serializer: JsonapiSerializer::FlightSerializer

    set_id :id
  end
end
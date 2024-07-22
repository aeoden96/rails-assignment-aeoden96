module JsonapiSerializer
  class UserSerializer
    include JSONAPI::Serializer

    attributes :first_name, :last_name, :email, :created_at, :updated_at

    has_many :bookings, serializer: JsonapiSerializer::BookingSerializer
    has_many :flights, serializer: JsonapiSerializer::FlightSerializer

    set_id :id
  end
end
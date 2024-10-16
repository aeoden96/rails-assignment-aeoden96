module JsonapiSerializer
  class FlightSerializer
    include JSONAPI::Serializer

    attributes :name, :base_price, :no_of_seats, :departs_at, :arrives_at, :created_at, :updated_at

    belongs_to :company, serializer: JsonapiSerializer::CompanySerializer

    set_id :id
  end
end

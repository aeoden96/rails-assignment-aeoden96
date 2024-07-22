module JsonapiSerializer
  class CompanySerializer
    include JSONAPI::Serializer

    attributes :name, :created_at, :updated_at

    has_many :flights, serializer: JsonapiSerializer::FlightSerializer

    set_id :id
  end
end

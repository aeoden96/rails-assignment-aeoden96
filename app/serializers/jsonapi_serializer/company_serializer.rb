module JsonapiSerializer
  class CompanySerializer
    include JSONAPI::Serializer

    attributes :name, :created_at, :updated_at
    set_id :id
  end
end

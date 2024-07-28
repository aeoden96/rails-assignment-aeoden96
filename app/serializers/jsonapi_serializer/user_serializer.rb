module JsonapiSerializer
  class UserSerializer
    include JSONAPI::Serializer

    attributes :first_name, :last_name, :email, :role, :created_at, :updated_at
    set_id :id
  end
end

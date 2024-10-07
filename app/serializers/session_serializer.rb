class SessionSerializer < Blueprinter::Base
  identifier :token
  field :token

  association :user, blueprint: UserSerializer
end

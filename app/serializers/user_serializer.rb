# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  attributes :name, :email, :created_at, :updated_at
end

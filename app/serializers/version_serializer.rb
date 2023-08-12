# frozen_string_literal: true

class VersionSerializer
  include JSONAPI::Serializer

  attributes :event, :changeset, :created_at
end

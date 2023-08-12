# frozen_string_literal: true

class TaskSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :status, :due_date, :priority, :created_at, :updated_at

  belongs_to :user
  has_many :versions
end

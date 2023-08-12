# frozen_string_literal: true

class Task < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :title, presence: true, length: { maximum: 100 }
  validates :status, :priority, presence: true

  # Enums
  enum status: { incomplete: 0, completed: 1 }
  enum priority: { low: 0, medium: 1, high: 2 }

  # Scopes
  scope :incomplete, -> { where(status: statuses[:incomplete]) }
  scope :completed, -> { where(status: statuses[:completed]) }
  scope :low_priority, -> { where(priority: priorities[:low]) }
  scope :medium_priority, -> { where(priority: priorities[:medium]) }
  scope :high_priority, -> { where(priority: priorities[:high]) }
end

# frozen_string_literal: true

class Task < ApplicationRecord
  # PaperTrail used for versioning
  has_paper_trail

  # PgSearch used for full text search
  include PgSearch::Model
  pg_search_scope :search_by_title_and_description,
                  against: %i[title description],
                  using: {
                    tsearch: { prefix: true },
                  }

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

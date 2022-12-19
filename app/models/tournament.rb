# frozen_string_literal: true

# model
class Tournament < ApplicationRecord
  enum status: { draft: 0, in_progress: 1, finished: 2 }

  # Associations
  has_many :participants, dependent: :destroy
  has_many :teams, through: :participants
  has_many :games, dependent: :destroy
  belongs_to :winner, class_name: 'Participant', optional: true
  belongs_to :finalist, class_name: 'Participant', optional: true

  # Validations
  validates :name, presence: true, uniqueness: true

  # Nested attirbutes
  accepts_nested_attributes_for :participants, allow_destroy: true
end

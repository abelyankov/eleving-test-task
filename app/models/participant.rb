# frozen_string_literal: true

# model
class Participant < ApplicationRecord
  enum division: { division1: 1, division2: 2 }

  # Associations
  belongs_to :team
  belongs_to :tournament, validate: true

  # Validations
  validates :team_id, uniqueness: { scope: :tournament_id }
  validate :maximum_participants, on: :create

  # Nested attributes
  accepts_nested_attributes_for :team, allow_destroy: true

  # Scopes
  scope :division, ->(division) { includes(:team).where(division: division) }

  private

  def maximum_participants
    errors.add(:tournament, 'has maximum number of participants') if tournament.participants.count >= 16
  end
end

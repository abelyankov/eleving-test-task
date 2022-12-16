# frozen_string_literal: true

class Game < ApplicationRecord
  # Associations
  belongs_to :tournament
  belongs_to :home, class_name: 'Participant', foreign_key: 'home_team_id'
  belongs_to :away, class_name: 'Participant', foreign_key: 'away_team_id'

  # Enums
  enum status: { division: 0, playoff: 1, quarter_final:2, final: 3 }
  enum division: { division1: 1, division2: 2 }

  # Scopes
  scope :division, ->(division) { includes(home: :team, away: :team).where(division: division) }
  scope :status, ->(status) { includes(home: :team, away: :team).where(status: status) }

  # Validations
  validates_uniqueness_of :home, scope: [:away, :tournament, :status]
  validates_uniqueness_of :away, scope: [:home, :tournament, :status]

  def home_winner?
    home_team_score > away_team_score
  end

  def away_winner?
    home_team_score < away_team_score
  end
end

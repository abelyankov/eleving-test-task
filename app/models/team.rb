# frozen_string_literal: true

class Team < ApplicationRecord
  # Validations
  validates :name, presence: true, uniqueness: true

  # Associations
  has_many :participants, dependent: :destroy
  has_many :tournaments, through: :participants
end

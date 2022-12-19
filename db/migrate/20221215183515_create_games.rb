# frozen_string_literal: true

# migration
class CreateGames < ActiveRecord::Migration[5.0]
  def change # rubocop:disable Metrics/MethodLength
    create_table :games do |t|
      t.string :name
      t.integer :division
      t.integer :status
      t.references :tournament
      t.references :home
      t.references :away
      t.integer :home_score
      t.integer :away_score
      t.timestamps
    end
  end
end

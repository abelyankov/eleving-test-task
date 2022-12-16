# frozen_string_literal: true

# migration
class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :division
      t.integer :status
      t.references :tournament
      t.references :home_team
      t.references :away_team
      t.integer :home_team_score
      t.integer :away_team_score
      t.timestamps
    end
  end
end

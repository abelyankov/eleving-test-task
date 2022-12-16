# frozen_string_literal: true

# migration
class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.integer :division
      t.integer :points, default: 0
      t.references :tournament
      t.references :team
      t.timestamps
    end
  end
end

# frozen_string_literal: true

# migration
class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false, uniqueness: true
      t.timestamps
    end
  end
end

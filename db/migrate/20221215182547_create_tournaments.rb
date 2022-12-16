# frozen_string_literal: true

# migration
class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :name, unique: true, null: false
      t.integer :status
      t.references :winner
      t.references :finalist
      t.timestamps
    end
  end
end

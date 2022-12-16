# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20221215183515) do

  create_table "games", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "division"
    t.integer  "status"
    t.integer  "tournament_id"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "home_team_score"
    t.integer  "away_team_score"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["away_team_id"], name: "index_games_on_away_team_id", using: :btree
    t.index ["home_team_id"], name: "index_games_on_home_team_id", using: :btree
    t.index ["tournament_id"], name: "index_games_on_tournament_id", using: :btree
  end

  create_table "participants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "division"
    t.integer  "points",        default: 0
    t.integer  "tournament_id"
    t.integer  "team_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["team_id"], name: "index_participants_on_team_id", using: :btree
    t.index ["tournament_id"], name: "index_participants_on_tournament_id", using: :btree
  end

  create_table "teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",        null: false
    t.integer  "status"
    t.integer  "winner_id"
    t.integer  "finalist_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["finalist_id"], name: "index_tournaments_on_finalist_id", using: :btree
    t.index ["winner_id"], name: "index_tournaments_on_winner_id", using: :btree
  end

end

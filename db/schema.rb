# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_04_29_104759) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.string "season"
    t.boolean "loser_scores_zero", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activity", default: "Bridge", null: false
    t.integer "match_total"
    t.index ["activity"], name: "index_leagues_on_activity"
    t.index ["name"], name: "index_leagues_on_name"
    t.index ["season"], name: "index_leagues_on_season"
  end

  create_table "matches", force: :cascade do |t|
    t.date "date"
    t.float "score"
    t.bigint "winner_id"
    t.bigint "loser_id"
    t.bigint "league_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_matches_on_date"
    t.index ["league_id"], name: "index_matches_on_league_id"
    t.index ["loser_id"], name: "index_matches_on_loser_id"
    t.index ["score"], name: "index_matches_on_score"
    t.index ["winner_id"], name: "index_matches_on_winner_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "priority", default: false
    t.index ["name"], name: "index_players_on_name", unique: true
    t.index ["priority"], name: "index_players_on_priority"
  end

  add_foreign_key "matches", "leagues"
  add_foreign_key "matches", "players", column: "loser_id"
  add_foreign_key "matches", "players", column: "winner_id"
end

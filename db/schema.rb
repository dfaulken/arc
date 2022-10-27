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

ActiveRecord::Schema.define(version: 2022_10_27_140627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "championship_drivers", force: :cascade do |t|
    t.integer "championship_id"
    t.integer "driver_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "car_number"
  end

  create_table "championships", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "warnings_convert_to_penalty_points"
    t.integer "number_of_warnings_per_penalty_point"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dropped_races", force: :cascade do |t|
    t.integer "race_result_id"
    t.integer "season_standing_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "incident_outcomes", force: :cascade do |t|
    t.integer "incident_id"
    t.integer "driver_id"
    t.boolean "received_warning"
    t.integer "penalty_points"
    t.datetime "expires_at"
    t.text "explanation"
    t.boolean "published"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "incidents", force: :cascade do |t|
    t.integer "race_id"
    t.integer "lap_number"
    t.string "reported_by"
    t.string "drivers_involved"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mods", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "approved"
    t.index ["confirmation_token"], name: "index_mods_on_confirmation_token", unique: true
    t.index ["email"], name: "index_mods_on_email", unique: true
    t.index ["reset_password_token"], name: "index_mods_on_reset_password_token", unique: true
  end

  create_table "points_allocations", force: :cascade do |t|
    t.integer "points_system_id"
    t.integer "position"
    t.integer "points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "points_systems", force: :cascade do |t|
    t.string "name"
    t.integer "worst_rounds_dropped"
    t.integer "pole_position_points"
    t.integer "any_lap_led_points"
    t.integer "most_laps_led_points"
    t.integer "race_finished_points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "team_results_counted_per_race"
  end

  create_table "race_results", force: :cascade do |t|
    t.integer "race_id"
    t.integer "driver_id"
    t.boolean "scored_pole_position"
    t.integer "laps_led"
    t.boolean "finished_race"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position"
    t.boolean "most_laps_led"
    t.boolean "disqualified"
  end

  create_table "races", force: :cascade do |t|
    t.integer "season_id"
    t.integer "track_id"
    t.date "date"
    t.integer "laps"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "scores", force: :cascade do |t|
    t.integer "race_result_id"
    t.integer "points_system_id"
    t.integer "points"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "season_standings", force: :cascade do |t|
    t.integer "season_id"
    t.integer "driver_id"
    t.integer "points"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "dropped_points"
    t.integer "base_points"
    t.string "track_type"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "championship_id"
    t.integer "points_system_id"
    t.integer "index"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "team_memberships", force: :cascade do |t|
    t.integer "team_id"
    t.integer "driver_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "team_standings", force: :cascade do |t|
    t.integer "team_id"
    t.integer "position"
    t.integer "points"
    t.string "track_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "teams", force: :cascade do |t|
    t.integer "season_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.string "track_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end

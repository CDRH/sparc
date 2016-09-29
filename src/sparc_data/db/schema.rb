# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160725142017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "codex_features", force: :cascade do |t|
    t.integer  "codex_id"
    t.integer  "feature_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "codex_rooms", force: :cascade do |t|
    t.integer  "codex_id"
    t.integer  "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "codexes", force: :cascade do |t|
    t.string   "room_no"
    t.string   "unit_type"
    t.string   "strat_all"
    t.string   "strat_alpha"
    t.string   "stratum_one"
    t.string   "alias_strats"
    t.string   "original_period"
    t.string   "dominant_occupation"
    t.text     "comments"
    t.integer  "room_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "stratum_two",         limit: 256
  end

  create_table "features", force: :cascade do |t|
    t.string   "feature_no"
    t.string   "strat"
    t.string   "floor_association"
    t.string   "feature_form"
    t.string   "other_associated_features"
    t.string   "grid"
    t.string   "depth_m_b_d"
    t.string   "occupation"
    t.string   "feature_type"
    t.integer  "feature_count"
    t.string   "feature_group"
    t.string   "residentual_feature"
    t.string   "real_feature"
    t.string   "location_in_room"
    t.text     "comments"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "room_no",                     limit: 255
    t.string   "t_shaped_door"
    t.string   "door_between_multiple_rooms"
    t.string   "doorway_sealed"
    t.string   "length_text"
    t.string   "width_text"
    t.string   "depth_height_text"
  end

  create_table "room_types", force: :cascade do |t|
    t.string   "description"
    t.string   "period"
    t.string   "location"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "room_no"
    t.string   "excavation_status"
    t.string   "occupation"
    t.string   "room_class"
    t.string   "stories"
    t.string   "intact_roof"
    t.integer  "room_type_id"
    t.string   "type_description"
    t.string   "inferred_function"
    t.string   "salmon_sector"
    t.text     "other_desc"
    t.string   "irregular_shape"
    t.string   "length_text"
    t.string   "width_text"
    t.string   "floor_area_text"
    t.text     "comments"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

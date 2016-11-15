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

ActiveRecord::Schema.define(version: 20161114192958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "art_types", force: :cascade do |t|
    t.string   "art_type",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["art_type"], name: "index_art_types_on_art_type", unique: true, using: :btree
  end

  create_table "bone_tool_occupations", force: :cascade do |t|
    t.string   "occupation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["occupation"], name: "index_bone_tool_occupations_on_occupation", unique: true, using: :btree
  end

  create_table "bone_tools", force: :cascade do |t|
    t.string   "room"
    t.string   "strat"
    t.string   "field_specimen_no"
    t.string   "depth"
    t.integer  "bone_tool_occupation_id"
    t.string   "grid"
    t.integer  "tool_type_code"
    t.string   "tool_type"
    t.integer  "species_code"
    t.text     "comments"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "bone_tools_strata", id: false, force: :cascade do |t|
    t.integer "bone_tool_id"
    t.integer "stratum_id"
    t.index ["bone_tool_id"], name: "index_bone_tools_strata_on_bone_tool_id", using: :btree
    t.index ["stratum_id"], name: "index_bone_tools_strata_on_stratum_id", using: :btree
  end

  create_table "door_between_multiple_rooms", force: :cascade do |t|
    t.string   "door_between_multiple_rooms", null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["door_between_multiple_rooms"], name: "door_between_rooms", unique: true, using: :btree
  end

  create_table "doorway_sealeds", force: :cascade do |t|
    t.string   "doorway_sealed", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["doorway_sealed"], name: "index_doorway_sealeds_on_doorway_sealed", unique: true, using: :btree
  end

  create_table "eggshell_affiliations", force: :cascade do |t|
    t.string   "affiliation", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["affiliation"], name: "index_eggshell_affiliations_on_affiliation", unique: true, using: :btree
  end

  create_table "eggshell_items", force: :cascade do |t|
    t.string   "item",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item"], name: "index_eggshell_items_on_item", unique: true, using: :btree
  end

  create_table "eggshells", force: :cascade do |t|
    t.integer  "stratum_id"
    t.string   "room"
    t.string   "strat"
    t.string   "salmon_museum_id_no"
    t.string   "record_field_key_no"
    t.string   "grid"
    t.string   "quad"
    t.string   "depth"
    t.string   "feature_no"
    t.string   "storage_bin"
    t.string   "museum_date"
    t.string   "field_date"
    t.integer  "eggshell_affiliation_id"
    t.integer  "eggshell_item_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "eggshells_features", id: false, force: :cascade do |t|
    t.integer "eggshell_id"
    t.integer "feature_id"
    t.index ["eggshell_id"], name: "index_eggshells_features_on_eggshell_id", using: :btree
    t.index ["feature_id"], name: "index_eggshells_features_on_feature_id", using: :btree
  end

  create_table "excavation_statuses", force: :cascade do |t|
    t.string   "excavation_status", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["excavation_status"], name: "index_excavation_statuses_on_excavation_status", unique: true, using: :btree
  end

  create_table "feature_groups", force: :cascade do |t|
    t.string   "feature_group", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["feature_group"], name: "index_feature_groups_on_feature_group", unique: true, using: :btree
  end

  create_table "feature_occupations", force: :cascade do |t|
    t.string   "occupation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["occupation"], name: "index_feature_occupations_on_occupation", unique: true, using: :btree
  end

  create_table "feature_types", force: :cascade do |t|
    t.string   "feature_type", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["feature_type"], name: "index_feature_types_on_feature_type", unique: true, using: :btree
  end

  create_table "features", force: :cascade do |t|
    t.string   "unit_no"
    t.string   "feature_no"
    t.string   "strat"
    t.string   "floor_association"
    t.string   "feature_form"
    t.string   "other_associated_features"
    t.string   "grid"
    t.string   "depth_m_b_d"
    t.integer  "feature_occupation_id"
    t.integer  "feature_type_id"
    t.integer  "feature_count"
    t.integer  "residential_feature_id"
    t.string   "real_feature"
    t.string   "location_in_room"
    t.integer  "feature_group_id"
    t.integer  "doorway_sealed_id"
    t.integer  "t_shaped_door_id"
    t.integer  "door_between_multiple_room_id"
    t.string   "length"
    t.string   "width"
    t.string   "depth_height"
    t.text     "comments"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "features_lithic_inventories", id: false, force: :cascade do |t|
    t.integer "lithic_inventory_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_lithic_inventories_on_feature_id", using: :btree
    t.index ["lithic_inventory_id"], name: "index_features_lithic_inventories_on_lithic_inventory_id", using: :btree
  end

  create_table "features_perishables", id: false, force: :cascade do |t|
    t.integer "perishable_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_perishables_on_feature_id", using: :btree
    t.index ["perishable_id"], name: "index_features_perishables_on_perishable_id", using: :btree
  end

  create_table "features_soils", id: false, force: :cascade do |t|
    t.integer "soil_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_soils_on_feature_id", using: :btree
    t.index ["soil_id"], name: "index_features_soils_on_soil_id", using: :btree
  end

  create_table "features_strata", id: false, force: :cascade do |t|
    t.integer "feature_id"
    t.integer "stratum_id"
    t.index ["feature_id"], name: "index_features_strata_on_feature_id", using: :btree
    t.index ["stratum_id"], name: "index_features_strata_on_stratum_id", using: :btree
  end

  create_table "inferred_functions", force: :cascade do |t|
    t.string   "inferred_function", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["inferred_function"], name: "index_inferred_functions_on_inferred_function", unique: true, using: :btree
  end

  create_table "intact_roofs", force: :cascade do |t|
    t.string   "intact_roof", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["intact_roof"], name: "index_intact_roofs_on_intact_roof", unique: true, using: :btree
  end

  create_table "irregular_shapes", force: :cascade do |t|
    t.string   "irregular_shape", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["irregular_shape"], name: "index_irregular_shapes_on_irregular_shape", unique: true, using: :btree
  end

  create_table "lithic_inventories", force: :cascade do |t|
    t.string   "site"
    t.string   "box"
    t.string   "fs"
    t.integer  "lithic_inventory_count"
    t.string   "gridew"
    t.string   "gridns"
    t.string   "quad"
    t.string   "exactprov"
    t.string   "depthbeg"
    t.string   "depthend"
    t.string   "stratalpha"
    t.integer  "strat_one"
    t.integer  "strat_two"
    t.string   "othstrats"
    t.string   "field_date"
    t.string   "excavator"
    t.string   "art_type"
    t.string   "sano"
    t.string   "recordkey"
    t.integer  "feature_id"
    t.text     "comments"
    t.string   "entby"
    t.string   "location"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "ornament_periods", force: :cascade do |t|
    t.string   "period",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["period"], name: "index_ornament_periods_on_period", unique: true, using: :btree
  end

  create_table "ornaments", force: :cascade do |t|
    t.string   "museum_specimen_no"
    t.string   "analysis_lab_no"
    t.string   "room"
    t.string   "strat"
    t.string   "grid"
    t.string   "quad"
    t.string   "depth"
    t.string   "field_date"
    t.integer  "ornament_period_id"
    t.integer  "feature_id"
    t.string   "analyst"
    t.string   "analyzed"
    t.string   "photographer"
    t.integer  "count"
    t.string   "item"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "perishable_periods", force: :cascade do |t|
    t.string   "period",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["period"], name: "index_perishable_periods_on_period", unique: true, using: :btree
  end

  create_table "perishables", force: :cascade do |t|
    t.string   "fs_number"
    t.string   "salmon_museum_number"
    t.string   "room"
    t.string   "strat"
    t.string   "grid"
    t.string   "quad"
    t.string   "depth"
    t.string   "asso_feature"
    t.integer  "perishable_period_id"
    t.string   "sa_no"
    t.string   "artifact_type"
    t.integer  "perishable_count"
    t.string   "artifact_structure"
    t.text     "comments"
    t.text     "other_comments"
    t.string   "storage_location"
    t.string   "exhibit_location"
    t.string   "record_key_no"
    t.string   "museum_lab_no"
    t.string   "field_date"
    t.text     "original_analysis"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "residential_features", force: :cascade do |t|
    t.string   "residential_feature", null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["residential_feature"], name: "index_residential_features_on_residential_feature", unique: true, using: :btree
  end

  create_table "room_types", force: :cascade do |t|
    t.string   "description"
    t.string   "period"
    t.string   "location"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "salmon_sectors", force: :cascade do |t|
    t.string   "salmon_sector", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["salmon_sector"], name: "index_salmon_sectors_on_salmon_sector", unique: true, using: :btree
  end

  create_table "select_artifact_occupations", force: :cascade do |t|
    t.string   "occupation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["occupation"], name: "index_select_artifact_occupations_on_occupation", unique: true, using: :btree
  end

  create_table "select_artifacts", force: :cascade do |t|
    t.string   "room"
    t.string   "artifact_no"
    t.string   "strat"
    t.string   "floor_association"
    t.string   "sa_form"
    t.string   "associated_feature_artifacts"
    t.string   "grid"
    t.string   "depth"
    t.integer  "select_artifact_occupation_id"
    t.string   "select_artifact_type"
    t.string   "artifact_count"
    t.string   "location_in_room"
    t.text     "comments"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "select_artifacts_strata", id: false, force: :cascade do |t|
    t.integer "select_artifact_id"
    t.integer "stratum_id"
    t.index ["select_artifact_id"], name: "index_select_artifacts_strata_on_select_artifact_id", using: :btree
    t.index ["stratum_id"], name: "index_select_artifacts_strata_on_stratum_id", using: :btree
  end

  create_table "soils", force: :cascade do |t|
    t.string   "site"
    t.string   "room"
    t.string   "strat"
    t.string   "feature_key"
    t.string   "fs"
    t.string   "box"
    t.string   "period"
    t.integer  "soil_count"
    t.string   "gridew"
    t.string   "gridns"
    t.string   "quad"
    t.string   "exactprov"
    t.string   "depthbeg"
    t.string   "depthend"
    t.string   "otherstrat"
    t.string   "date"
    t.string   "excavator"
    t.integer  "art_type_id"
    t.string   "sample_no"
    t.text     "comments"
    t.text     "data_entry"
    t.string   "location"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string   "story",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story"], name: "index_stories_on_story", unique: true, using: :btree
  end

  create_table "strat_occupations", force: :cascade do |t|
    t.string   "occupation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["occupation"], name: "index_strat_occupations_on_occupation", unique: true, using: :btree
  end

  create_table "strat_types", force: :cascade do |t|
    t.string   "code",       null: false
    t.string   "strat_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_strat_types_on_code", unique: true, using: :btree
  end

  create_table "strata", force: :cascade do |t|
    t.integer  "unit_id"
    t.string   "strat_all"
    t.string   "strat_alpha"
    t.integer  "strat_type_id"
    t.string   "stratum_one"
    t.string   "stratum_two"
    t.string   "stratum_three"
    t.integer  "strat_occupation_id"
    t.text     "comments"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "t_shaped_doors", force: :cascade do |t|
    t.string   "t_shaped_door", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["t_shaped_door"], name: "index_t_shaped_doors_on_t_shaped_door", unique: true, using: :btree
  end

  create_table "type_descriptions", force: :cascade do |t|
    t.string   "type_description", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["type_description"], name: "index_type_descriptions_on_type_description", unique: true, using: :btree
  end

  create_table "unit_classes", force: :cascade do |t|
    t.string   "unit_class", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_class"], name: "index_unit_classes_on_unit_class", unique: true, using: :btree
  end

  create_table "unit_occupations", force: :cascade do |t|
    t.string   "occupation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["occupation"], name: "index_unit_occupations_on_occupation", unique: true, using: :btree
  end

  create_table "units", force: :cascade do |t|
    t.string   "unit_no",              null: false
    t.integer  "excavation_status_id"
    t.integer  "unit_occupation_id"
    t.integer  "unit_class_id"
    t.integer  "story_id"
    t.integer  "intact_roof_id"
    t.string   "salmon_type_code"
    t.integer  "type_description_id"
    t.integer  "inferred_function_id"
    t.integer  "salmon_sector_id"
    t.text     "other_description"
    t.integer  "irregular_shape_id"
    t.integer  "room_type_id"
    t.string   "length"
    t.string   "width"
    t.string   "floor_area"
    t.text     "comments"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["unit_no"], name: "index_units_on_unit_no", unique: true, using: :btree
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
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "bone_tools", "bone_tool_occupations"
  add_foreign_key "bone_tools_strata", "bone_tools"
  add_foreign_key "bone_tools_strata", "strata"
  add_foreign_key "eggshells", "eggshell_affiliations"
  add_foreign_key "eggshells", "eggshell_items"
  add_foreign_key "eggshells_features", "eggshells"
  add_foreign_key "eggshells_features", "features"
  add_foreign_key "features", "door_between_multiple_rooms"
  add_foreign_key "features", "doorway_sealeds"
  add_foreign_key "features", "feature_groups"
  add_foreign_key "features", "feature_occupations"
  add_foreign_key "features", "feature_types"
  add_foreign_key "features", "residential_features"
  add_foreign_key "features", "t_shaped_doors"
  add_foreign_key "features_lithic_inventories", "features"
  add_foreign_key "features_lithic_inventories", "lithic_inventories"
  add_foreign_key "features_perishables", "features"
  add_foreign_key "features_perishables", "perishables"
  add_foreign_key "features_soils", "features"
  add_foreign_key "features_soils", "soils"
  add_foreign_key "features_strata", "features"
  add_foreign_key "features_strata", "strata"
  add_foreign_key "lithic_inventories", "features"
  add_foreign_key "ornaments", "features"
  add_foreign_key "ornaments", "ornament_periods"
  add_foreign_key "perishables", "perishable_periods"
  add_foreign_key "select_artifacts", "select_artifact_occupations"
  add_foreign_key "select_artifacts_strata", "select_artifacts"
  add_foreign_key "select_artifacts_strata", "strata"
  add_foreign_key "soils", "art_types"
  add_foreign_key "strata", "strat_occupations"
  add_foreign_key "strata", "strat_types"
  add_foreign_key "strata", "units"
  add_foreign_key "units", "excavation_statuses"
  add_foreign_key "units", "inferred_functions"
  add_foreign_key "units", "intact_roofs"
  add_foreign_key "units", "irregular_shapes"
  add_foreign_key "units", "room_types"
  add_foreign_key "units", "salmon_sectors"
  add_foreign_key "units", "stories"
  add_foreign_key "units", "type_descriptions"
  add_foreign_key "units", "unit_classes"
end

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

ActiveRecord::Schema.define(version: 2020_05_04_184851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "art_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_art_types_on_name", unique: true
  end

  create_table "bone_tools", id: :serial, force: :cascade do |t|
    t.string "unit"
    t.string "strat"
    t.string "fs_no"
    t.string "depth"
    t.string "grid"
    t.integer "tool_type_code"
    t.string "tool_type"
    t.integer "species_code"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "occupation_id"
    t.integer "faunal_inventory_id"
    t.integer "feature_id"
    t.string "strat_other"
    t.string "sa_no"
    t.index ["faunal_inventory_id"], name: "index_bone_tools_on_faunal_inventory_id"
    t.index ["feature_id"], name: "index_bone_tools_on_feature_id"
    t.index ["occupation_id"], name: "index_bone_tools_on_occupation_id"
  end

  create_table "burial_sexes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "burials", id: :serial, force: :cascade do |t|
    t.string "unit"
    t.string "strat"
    t.string "feature_no"
    t.string "new_burial_no"
    t.string "age"
    t.string "grid_ns"
    t.string "grid_ew"
    t.string "quad"
    t.string "depth_begin"
    t.string "depth_end"
    t.string "date"
    t.string "excavator"
    t.string "record_field_key_no"
    t.string "associated_artifacts"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "feature_id"
    t.integer "burial_sex_id"
    t.integer "occupation_id"
    t.index ["burial_sex_id"], name: "index_burials_on_burial_sex_id"
    t.index ["feature_id"], name: "index_burials_on_feature_id"
    t.index ["occupation_id"], name: "index_burials_on_occupation_id"
  end

  create_table "ceramic_clap_group_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_clap_tempers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_clap_traditions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_clap_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_clap_vessel_forms", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_claps", id: :serial, force: :cascade do |t|
    t.string "unit"
    t.string "strat"
    t.string "feature_no"
    t.string "record_field_key_no"
    t.string "grid"
    t.string "depth_begin"
    t.string "depth_end"
    t.string "field_year"
    t.integer "sherd_lot_no"
    t.string "frequency"
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ceramic_clap_type_id"
    t.integer "ceramic_clap_group_type_id"
    t.integer "ceramic_clap_tradition_id"
    t.integer "ceramic_clap_vessel_form_id"
    t.integer "ceramic_clap_temper_id"
    t.index ["ceramic_clap_group_type_id"], name: "index_ceramic_claps_on_ceramic_clap_group_type_id"
    t.index ["ceramic_clap_temper_id"], name: "index_ceramic_claps_on_ceramic_clap_temper_id"
    t.index ["ceramic_clap_tradition_id"], name: "index_ceramic_claps_on_ceramic_clap_tradition_id"
    t.index ["ceramic_clap_type_id"], name: "index_ceramic_claps_on_ceramic_clap_type_id"
    t.index ["ceramic_clap_vessel_form_id"], name: "index_ceramic_claps_on_ceramic_clap_vessel_form_id"
  end

  create_table "ceramic_claps_features", id: false, force: :cascade do |t|
    t.integer "ceramic_clap_id"
    t.integer "feature_id"
    t.index ["ceramic_clap_id"], name: "index_ceramic_claps_features_on_ceramic_clap_id"
    t.index ["feature_id"], name: "index_ceramic_claps_features_on_feature_id"
  end

  create_table "ceramic_exterior_pigments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_exterior_surfaces", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_interior_pigments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_interior_surfaces", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_inventories", id: :serial, force: :cascade do |t|
    t.string "site"
    t.string "box"
    t.string "fs_no"
    t.integer "count"
    t.string "grid_ew"
    t.string "grid_ns"
    t.string "quad"
    t.string "exact_prov"
    t.string "depth_begin"
    t.string "depth_end"
    t.string "strat_alpha"
    t.integer "strat_one"
    t.integer "strat_two"
    t.string "strat_other"
    t.string "field_date"
    t.string "excavator"
    t.string "art_type"
    t.string "sa_no"
    t.string "record_field_key_no"
    t.integer "feature_id"
    t.text "comments"
    t.string "entered_by"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "select_artifact_info"
  end

  create_table "ceramic_inventories_features", id: false, force: :cascade do |t|
    t.integer "feature_id"
    t.integer "ceramic_inventory_id"
    t.index ["ceramic_inventory_id"], name: "index_ceramic_inventories_features_on_ceramic_inventory_id"
    t.index ["feature_id"], name: "index_ceramic_inventories_features_on_feature_id"
  end

  create_table "ceramic_pastes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_slips", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_specific_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_styles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_tempers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_traditions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_varieties", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_vessel_appendages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_vessel_forms", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_vessel_lori_reed_forms", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_vessel_lori_reed_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_vessel_parts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_vessel_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_vessels", id: :serial, force: :cascade do |t|
    t.string "unit"
    t.string "strat"
    t.string "strat_other"
    t.string "feature_no"
    t.string "sa_no"
    t.string "fs_no"
    t.string "salmon_vessel_no"
    t.string "pottery_order_no"
    t.string "record_field_key_no"
    t.string "vessel_percentage"
    t.string "lori_reed_analysis"
    t.string "comments_lori_reed"
    t.string "comments_other"
    t.integer "feature_id"
    t.integer "ceramic_whole_vessel_form_id"
    t.integer "ceramic_vessel_lori_reed_form_id"
    t.integer "ceramic_vessel_type_id"
    t.integer "ceramic_vessel_lori_reed_type_id"
    t.integer "ceramic_inventory_id"
    t.string "select_artifact_info"
    t.boolean "burial_related"
    t.index ["ceramic_inventory_id"], name: "index_ceramic_vessels_on_ceramic_inventory_id"
    t.index ["ceramic_vessel_lori_reed_form_id"], name: "index_ceramic_vessels_on_ceramic_vessel_lori_reed_form_id"
    t.index ["ceramic_vessel_lori_reed_type_id"], name: "index_ceramic_vessels_on_ceramic_vessel_lori_reed_type_id"
    t.index ["ceramic_vessel_type_id"], name: "index_ceramic_vessels_on_ceramic_vessel_type_id"
    t.index ["ceramic_whole_vessel_form_id"], name: "index_ceramic_vessels_on_ceramic_whole_vessel_form_id"
    t.index ["feature_id"], name: "index_ceramic_vessels_on_feature_id"
  end

  create_table "ceramic_wares", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramic_whole_vessel_forms", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ceramics", id: :serial, force: :cascade do |t|
    t.string "site"
    t.string "fs_no"
    t.integer "lot_no"
    t.integer "cat_no"
    t.string "unit"
    t.string "strat"
    t.string "feature_no"
    t.string "sa_no"
    t.string "pulled_sample"
    t.decimal "wall_thickness"
    t.decimal "rim_radius"
    t.integer "rim_arc"
    t.integer "rim_eversion"
    t.string "residues"
    t.string "modification"
    t.integer "count"
    t.decimal "weight"
    t.string "vessel_no"
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "feature_id"
    t.integer "ceramic_vessel_form_id"
    t.integer "ceramic_vessel_part_id"
    t.integer "ceramic_exterior_pigment_id"
    t.integer "ceramic_interior_pigment_id"
    t.integer "ceramic_exterior_surface_id"
    t.integer "ceramic_interior_surface_id"
    t.integer "ceramic_vessel_appendage_id"
    t.integer "ceramic_temper_id"
    t.integer "ceramic_paste_id"
    t.integer "ceramic_slip_id"
    t.integer "ceramic_tradition_id"
    t.integer "ceramic_variety_id"
    t.integer "ceramic_ware_id"
    t.integer "ceramic_specific_type_id"
    t.integer "ceramic_style_id"
    t.integer "ceramic_inventory_id"
    t.index ["ceramic_exterior_pigment_id"], name: "index_ceramics_on_ceramic_exterior_pigment_id"
    t.index ["ceramic_exterior_surface_id"], name: "index_ceramics_on_ceramic_exterior_surface_id"
    t.index ["ceramic_interior_pigment_id"], name: "index_ceramics_on_ceramic_interior_pigment_id"
    t.index ["ceramic_interior_surface_id"], name: "index_ceramics_on_ceramic_interior_surface_id"
    t.index ["ceramic_inventory_id"], name: "index_ceramics_on_ceramic_inventory_id"
    t.index ["ceramic_paste_id"], name: "index_ceramics_on_ceramic_paste_id"
    t.index ["ceramic_slip_id"], name: "index_ceramics_on_ceramic_slip_id"
    t.index ["ceramic_specific_type_id"], name: "index_ceramics_on_ceramic_specific_type_id"
    t.index ["ceramic_style_id"], name: "index_ceramics_on_ceramic_style_id"
    t.index ["ceramic_temper_id"], name: "index_ceramics_on_ceramic_temper_id"
    t.index ["ceramic_tradition_id"], name: "index_ceramics_on_ceramic_tradition_id"
    t.index ["ceramic_variety_id"], name: "index_ceramics_on_ceramic_variety_id"
    t.index ["ceramic_vessel_appendage_id"], name: "index_ceramics_on_ceramic_vessel_appendage_id"
    t.index ["ceramic_vessel_form_id"], name: "index_ceramics_on_ceramic_vessel_form_id"
    t.index ["ceramic_vessel_part_id"], name: "index_ceramics_on_ceramic_vessel_part_id"
    t.index ["ceramic_ware_id"], name: "index_ceramics_on_ceramic_ware_id"
    t.index ["feature_id"], name: "index_ceramics_on_feature_id"
  end

  create_table "document_binders", id: :serial, force: :cascade do |t|
    t.string "resource_id"
    t.string "title"
    t.string "subtitle"
    t.string "creator"
    t.string "creator_role"
    t.string "earliest_date"
    t.string "latest_date"
    t.string "dimensions"
    t.string "language"
    t.string "description"
    t.string "condition"
    t.string "rights"
    t.string "rights_holder"
    t.string "access_level"
    t.string "repository"
    t.string "accession_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_metadata", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "region"
    t.string "modern_name"
    t.string "location_id"
    t.string "location_id_scheme"
    t.string "geolocation"
    t.string "elevation"
    t.string "earliest_date"
    t.string "latest_date"
    t.string "records_archive"
    t.string "persistent_name"
    t.string "complex_title"
    t.string "terminus_ante_quem"
    t.string "terminus_post_quem"
    t.string "period"
    t.string "archaeological_culture"
    t.string "brief_description"
    t.string "permitting_heritage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_types", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "color"
    t.string "rank"
  end

  create_table "documents", id: :serial, force: :cascade do |t|
    t.string "format"
    t.string "page_id"
    t.string "scan_no"
    t.string "image_upload"
    t.string "scan_specifications"
    t.string "scan_equipment"
    t.string "scan_date"
    t.string "scan_creator"
    t.string "scan_creator_status"
    t.string "rights"
    t.string "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "document_binder_id"
    t.integer "document_type_id"
    t.index ["document_binder_id"], name: "index_documents_on_document_binder_id"
    t.index ["document_type_id"], name: "index_documents_on_document_type_id"
  end

  create_table "documents_units", id: false, force: :cascade do |t|
    t.integer "document_id"
    t.integer "unit_id"
    t.index ["document_id"], name: "index_documents_units_on_document_id"
    t.index ["unit_id"], name: "index_documents_units_on_unit_id"
  end

  create_table "door_between_multiple_rooms", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "door_between_rooms", unique: true
  end

  create_table "doorway_sealeds", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_doorway_sealeds_on_name", unique: true
  end

  create_table "eggshell_items", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_eggshell_items_on_name", unique: true
  end

  create_table "eggshells", id: :serial, force: :cascade do |t|
    t.string "unit"
    t.string "strat"
    t.string "salmon_museum_no"
    t.string "record_field_key_no"
    t.string "grid"
    t.string "quad"
    t.string "depth"
    t.string "feature_no"
    t.string "storage_bin"
    t.string "museum_date"
    t.string "field_date"
    t.integer "eggshell_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "occupation_id"
    t.index ["occupation_id"], name: "index_eggshells_on_occupation_id"
  end

  create_table "eggshells_features", id: false, force: :cascade do |t|
    t.integer "eggshell_id"
    t.integer "feature_id"
    t.index ["eggshell_id"], name: "index_eggshells_features_on_eggshell_id"
    t.index ["feature_id"], name: "index_eggshells_features_on_feature_id"
  end

  create_table "excavation_statuses", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_excavation_statuses_on_name", unique: true
  end

  create_table "faunal_artifacts", id: :serial, force: :cascade do |t|
    t.string "fs_no"
    t.string "artifact_no"
    t.string "unit"
    t.string "strat"
    t.string "feature_no"
    t.string "grid_ew"
    t.string "grid_ns"
    t.string "depth_begin"
    t.string "depth_end"
    t.string "spc"
    t.string "elem"
    t.string "side"
    t.string "cond"
    t.string "frag"
    t.string "pd"
    t.string "dv"
    t.string "fuse"
    t.string "burn"
    t.string "art"
    t.string "gnaw"
    t.string "mod"
    t.string "bmark"
    t.string "frags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "faunal_inventory_id"
    t.integer "feature_id"
    t.index ["faunal_inventory_id"], name: "index_faunal_artifacts_on_faunal_inventory_id"
    t.index ["feature_id"], name: "index_faunal_artifacts_on_feature_id"
  end

  create_table "faunal_inventories", id: :serial, force: :cascade do |t|
    t.string "site"
    t.string "box"
    t.string "fs_no"
    t.integer "count"
    t.string "grid_ew"
    t.string "grid_ns"
    t.string "quad"
    t.string "exact_prov"
    t.string "depth_begin"
    t.string "depth_end"
    t.string "strat_alpha"
    t.integer "strat_one"
    t.integer "strat_two"
    t.string "strat_other"
    t.string "field_date"
    t.string "excavator"
    t.string "art_type"
    t.string "sa_no"
    t.string "record_field_key_no"
    t.integer "feature_id"
    t.text "comments"
    t.string "entered_by"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "select_artifact_info"
  end

  create_table "faunal_inventories_features", id: false, force: :cascade do |t|
    t.integer "feature_id"
    t.integer "faunal_inventory_id"
    t.index ["faunal_inventory_id"], name: "index_faunal_inventories_features_on_faunal_inventory_id"
    t.index ["feature_id"], name: "index_faunal_inventories_features_on_feature_id"
  end

  create_table "feature_groups", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_feature_groups_on_name", unique: true
  end

  create_table "feature_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_feature_types_on_name", unique: true
  end

  create_table "features", id: :serial, force: :cascade do |t|
    t.string "unit_no"
    t.string "feature_no"
    t.string "strat"
    t.string "floor_association"
    t.string "feature_form"
    t.string "other_associated_features"
    t.string "grid"
    t.string "depth_mbd"
    t.integer "feature_type_id"
    t.integer "count"
    t.integer "residential_feature_id"
    t.string "real_feature"
    t.string "location_in_room"
    t.integer "feature_group_id"
    t.integer "doorway_sealed_id"
    t.integer "t_shaped_door_id"
    t.integer "door_between_multiple_room_id"
    t.string "length"
    t.string "width"
    t.string "depth_height"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "occupation_id"
    t.index ["occupation_id"], name: "index_features_on_occupation_id"
  end

  create_table "features_images", id: false, force: :cascade do |t|
    t.integer "image_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_images_on_feature_id"
    t.index ["image_id"], name: "index_features_images_on_image_id"
  end

  create_table "features_lithic_debitages", id: false, force: :cascade do |t|
    t.integer "lithic_debitage_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_lithic_debitages_on_feature_id"
    t.index ["lithic_debitage_id"], name: "index_features_lithic_debitages_on_lithic_debitage_id"
  end

  create_table "features_lithic_inventories", id: false, force: :cascade do |t|
    t.integer "lithic_inventory_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_lithic_inventories_on_feature_id"
    t.index ["lithic_inventory_id"], name: "index_features_lithic_inventories_on_lithic_inventory_id"
  end

  create_table "features_lithic_tools", id: false, force: :cascade do |t|
    t.integer "lithic_tool_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_lithic_tools_on_feature_id"
    t.index ["lithic_tool_id"], name: "index_features_lithic_tools_on_lithic_tool_id"
  end

  create_table "features_perishables", id: false, force: :cascade do |t|
    t.integer "perishable_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_perishables_on_feature_id"
    t.index ["perishable_id"], name: "index_features_perishables_on_perishable_id"
  end

  create_table "features_pollen_inventories", id: false, force: :cascade do |t|
    t.integer "pollen_inventory_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_pollen_inventories_on_feature_id"
    t.index ["pollen_inventory_id"], name: "index_features_pollen_inventories_on_pollen_inventory_id"
  end

  create_table "features_select_artifacts", id: false, force: :cascade do |t|
    t.integer "select_artifact_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_select_artifacts_on_feature_id"
    t.index ["select_artifact_id"], name: "index_features_select_artifacts_on_select_artifact_id"
  end

  create_table "features_soils", id: false, force: :cascade do |t|
    t.integer "soil_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_soils_on_feature_id"
    t.index ["soil_id"], name: "index_features_soils_on_soil_id"
  end

  create_table "features_strata", id: false, force: :cascade do |t|
    t.integer "feature_id"
    t.integer "stratum_id"
    t.index ["feature_id"], name: "index_features_strata_on_feature_id"
    t.index ["stratum_id"], name: "index_features_strata_on_stratum_id"
  end

  create_table "features_wood_inventories", id: false, force: :cascade do |t|
    t.integer "wood_inventory_id"
    t.integer "feature_id"
    t.index ["feature_id"], name: "index_features_wood_inventories_on_feature_id"
    t.index ["wood_inventory_id"], name: "index_features_wood_inventories_on_wood_inventory_id"
  end

  create_table "image_boxes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_creators", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_formats", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_human_remains", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "displayable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_orientations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_qualities", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_subjects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_subjects_images", id: false, force: :cascade do |t|
    t.integer "image_id", null: false
    t.integer "image_subject_id", null: false
    t.integer "images_id"
    t.integer "image_subjects_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_subjects_id"], name: "index_image_subjects_images_on_image_subjects_id"
    t.index ["images_id"], name: "index_image_subjects_images_on_images_id"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "site"
    t.string "unit"
    t.string "strat"
    t.string "associated_features"
    t.string "image_no"
    t.string "grid_ew"
    t.string "grid_ns"
    t.string "depth_begin"
    t.string "depth_end"
    t.string "date"
    t.string "sa_no"
    t.string "other_no"
    t.string "comments"
    t.string "storage_location"
    t.string "entered_by"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_box_id"
    t.integer "image_creator_id"
    t.integer "image_format_id"
    t.integer "image_human_remain_id"
    t.integer "image_orientation_id"
    t.integer "image_quality_id"
    t.string "strat_other"
    t.string "orig_subjects"
    t.boolean "file_exists"
    t.index ["image_box_id"], name: "index_images_on_image_box_id"
    t.index ["image_creator_id"], name: "index_images_on_image_creator_id"
    t.index ["image_format_id"], name: "index_images_on_image_format_id"
    t.index ["image_human_remain_id"], name: "index_images_on_image_human_remain_id"
    t.index ["image_orientation_id"], name: "index_images_on_image_orientation_id"
    t.index ["image_quality_id"], name: "index_images_on_image_quality_id"
  end

  create_table "inferred_functions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_inferred_functions_on_name", unique: true
  end

  create_table "intact_roofs", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_intact_roofs_on_name", unique: true
  end

  create_table "irregular_shapes", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_irregular_shapes_on_name", unique: true
  end

  create_table "lithic_artifact_types", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lithic_conditions", id: :serial, force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lithic_debitages", id: :serial, force: :cascade do |t|
    t.string "unit"
    t.string "fs_no"
    t.string "artifact_no"
    t.string "artifact_type"
    t.string "fire_altered"
    t.string "utilized"
    t.integer "cortex_percentage"
    t.integer "cortical_flakes"
    t.integer "non_cortical_flakes"
    t.decimal "length"
    t.decimal "width"
    t.decimal "thickness"
    t.decimal "weight"
    t.string "comments"
    t.integer "total_flakes_in_bag"
    t.integer "lithic_inventory_id"
    t.integer "lithic_material_type_id"
    t.integer "lithic_condition_id"
    t.integer "lithic_platform_type_id"
    t.integer "lithic_termination_id"
    t.index ["lithic_condition_id"], name: "index_lithic_debitages_on_lithic_condition_id"
    t.index ["lithic_inventory_id"], name: "index_lithic_debitages_on_lithic_inventory_id"
    t.index ["lithic_material_type_id"], name: "index_lithic_debitages_on_lithic_material_type_id"
    t.index ["lithic_platform_type_id"], name: "index_lithic_debitages_on_lithic_platform_type_id"
    t.index ["lithic_termination_id"], name: "index_lithic_debitages_on_lithic_termination_id"
  end

  create_table "lithic_inventories", id: :serial, force: :cascade do |t|
    t.string "site"
    t.string "box"
    t.string "fs_no"
    t.integer "count"
    t.string "grid_ew"
    t.string "grid_ns"
    t.string "quad"
    t.string "exact_prov"
    t.string "depth_begin"
    t.string "depth_end"
    t.string "strat_alpha"
    t.integer "strat_one"
    t.integer "strat_two"
    t.string "strat_other"
    t.string "field_date"
    t.string "excavator"
    t.string "art_type"
    t.string "sa_no"
    t.string "record_field_key_no"
    t.integer "feature_id"
    t.text "comments"
    t.string "entered_by"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "select_artifact_info"
  end

  create_table "lithic_material_types", id: :serial, force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lithic_platform_types", id: :serial, force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lithic_terminations", id: :serial, force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lithic_tools", id: :serial, force: :cascade do |t|
    t.string "unit"
    t.string "fs_no"
    t.string "artifact_no"
    t.string "fire_altered"
    t.string "utilized"
    t.integer "cortex_percentage"
    t.integer "cortical_flakes"
    t.integer "non_cortical_flakes"
    t.integer "length"
    t.integer "width"
    t.integer "thickness"
    t.integer "weight"
    t.string "comments"
    t.integer "lithic_inventory_id"
    t.integer "lithic_artifact_type_id"
    t.integer "lithic_material_type_id"
    t.integer "lithic_condition_id"
    t.integer "lithic_platform_type_id"
    t.integer "lithic_termination_id"
    t.index ["lithic_artifact_type_id"], name: "index_lithic_tools_on_lithic_artifact_type_id"
    t.index ["lithic_condition_id"], name: "index_lithic_tools_on_lithic_condition_id"
    t.index ["lithic_inventory_id"], name: "index_lithic_tools_on_lithic_inventory_id"
    t.index ["lithic_material_type_id"], name: "index_lithic_tools_on_lithic_material_type_id"
    t.index ["lithic_platform_type_id"], name: "index_lithic_tools_on_lithic_platform_type_id"
    t.index ["lithic_termination_id"], name: "index_lithic_tools_on_lithic_termination_id"
  end

  create_table "obsidian_identified_sources", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "obsidian_inventories", id: :serial, force: :cascade do |t|
    t.string "site"
    t.string "box"
    t.string "fs_no"
    t.integer "count"
    t.string "unit"
    t.string "strat"
    t.string "strat_other"
    t.string "feature_no"
    t.string "lithic_id"
    t.string "material_type"
    t.string "shackley_sourcing"
    t.string "grid_ew"
    t.string "grid_ns"
    t.string "quad"
    t.string "exact_prov"
    t.string "artifact_type"
    t.string "depth_begin"
    t.string "depth_end"
    t.string "date"
    t.string "excavator"
    t.string "record_field_key_no"
    t.string "comments"
    t.string "entered_by"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "obsidian_identified_source_id"
    t.integer "feature_id"
    t.integer "occupation_id"
    t.index ["feature_id"], name: "index_obsidian_inventories_on_feature_id"
    t.index ["obsidian_identified_source_id"], name: "index_obsidian_inventories_on_obsidian_identified_source_id"
    t.index ["occupation_id"], name: "index_obsidian_inventories_on_occupation_id"
  end

  create_table "occupations", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_occupations_on_name", unique: true
  end

  create_table "ornaments", id: :serial, force: :cascade do |t|
    t.string "salmon_museum_no"
    t.string "analysis_lab_no"
    t.string "unit"
    t.string "strat"
    t.string "grid"
    t.string "quad"
    t.string "depth"
    t.string "field_date"
    t.integer "feature_id"
    t.string "analyst"
    t.string "analyzed"
    t.string "photographer"
    t.integer "count"
    t.string "item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "occupation_id"
    t.string "sa_no"
    t.string "strat_other"
    t.string "select_artifact_info"
    t.index ["occupation_id"], name: "index_ornaments_on_occupation_id"
  end

  create_table "perishables", id: :serial, force: :cascade do |t|
    t.string "fs_no"
    t.string "salmon_museum_number"
    t.string "unit"
    t.string "strat"
    t.string "grid"
    t.string "quad"
    t.string "depth"
    t.string "associated_feature"
    t.string "sa_no"
    t.string "artifact_type"
    t.integer "count"
    t.string "artifact_structure"
    t.text "comments"
    t.text "comments_other"
    t.string "storage_location"
    t.string "exhibit_location"
    t.string "record_field_key_no"
    t.string "museum_lab_no"
    t.string "field_date"
    t.text "original_analysis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "occupation_id"
    t.string "select_artifact_info"
    t.index ["occupation_id"], name: "index_perishables_on_occupation_id"
  end

  create_table "pollen_inventories", id: :serial, force: :cascade do |t|
    t.string "unit"
    t.string "strat"
    t.string "strat_other"
    t.string "salmon_museum_no"
    t.string "sa_no"
    t.string "grid"
    t.string "quad"
    t.string "depth"
    t.string "box"
    t.string "record_field_key_no"
    t.string "other_sample_no"
    t.string "date"
    t.string "analysis_completed"
    t.string "frequency"
  end

  create_table "residential_features", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_residential_features_on_name", unique: true
  end

  create_table "salmon_sectors", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_salmon_sectors_on_name", unique: true
  end

  create_table "select_artifacts", id: :serial, force: :cascade do |t|
    t.string "unit"
    t.string "sa_no"
    t.string "strat"
    t.string "floor_association"
    t.string "sa_form"
    t.string "associated_feature_artifacts"
    t.string "grid"
    t.string "depth"
    t.string "select_artifact_type"
    t.string "artifact_count"
    t.string "location_in_room"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "occupation_id"
    t.string "feature_no"
    t.string "appears_in_table"
    t.string "strat_other"
    t.index ["occupation_id"], name: "index_select_artifacts_on_occupation_id"
  end

  create_table "soils", id: :serial, force: :cascade do |t|
    t.string "site"
    t.string "unit"
    t.string "strat"
    t.string "feature_key"
    t.string "fs_no"
    t.string "box"
    t.integer "count"
    t.string "grid_ew"
    t.string "grid_ns"
    t.string "quad"
    t.string "exact_prov"
    t.string "depth_begin"
    t.string "depth_end"
    t.string "strat_other"
    t.string "date"
    t.string "excavator"
    t.integer "art_type_id"
    t.string "sample_no"
    t.text "comments"
    t.text "entered_by"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "species_tree_rings", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stories_on_name", unique: true
  end

  create_table "strat_groupings", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "strat_types", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "strat_grouping_id"
    t.index ["code"], name: "index_strat_types_on_code", unique: true
    t.index ["strat_grouping_id"], name: "index_strat_types_on_strat_grouping_id"
  end

  create_table "strata", id: :serial, force: :cascade do |t|
    t.integer "unit_id"
    t.string "strat_all"
    t.string "strat_alpha"
    t.integer "strat_type_id"
    t.string "strat_one"
    t.string "strat_two"
    t.string "strat_three"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "occupation_id"
    t.index ["occupation_id"], name: "index_strata_on_occupation_id"
  end

  create_table "t_shaped_doors", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_t_shaped_doors_on_name", unique: true
  end

  create_table "tree_rings", id: :serial, force: :cascade do |t|
    t.string "site"
    t.string "unit_no"
    t.string "record_field_key_no"
    t.string "strat"
    t.string "feature_no"
    t.string "trl_no"
    t.string "year_dated"
    t.string "windes_sample"
    t.string "field_no"
    t.string "inner_date"
    t.string "outer_date"
    t.string "symbol"
    t.string "cutting_date"
    t.string "comments"
    t.integer "stratum_id"
    t.integer "occupation_id"
    t.integer "species_tree_ring_id"
    t.index ["occupation_id"], name: "index_tree_rings_on_occupation_id"
    t.index ["species_tree_ring_id"], name: "index_tree_rings_on_species_tree_ring_id"
    t.index ["stratum_id"], name: "index_tree_rings_on_stratum_id"
  end

  create_table "type_descriptions", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_type_descriptions_on_name", unique: true
  end

  create_table "unit_classes", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code", default: ""
    t.index ["name"], name: "index_unit_classes_on_name", unique: true
  end

  create_table "units", id: :serial, force: :cascade do |t|
    t.string "unit_no", null: false
    t.integer "excavation_status_id"
    t.integer "unit_class_id"
    t.integer "story_id"
    t.integer "intact_roof_id"
    t.string "salmon_type_code"
    t.integer "type_description_id"
    t.integer "inferred_function_id"
    t.integer "salmon_sector_id"
    t.text "other_description"
    t.integer "irregular_shape_id"
    t.string "length"
    t.string "width"
    t.string "floor_area"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "zone_id"
    t.integer "occupation_id"
    t.text "description"
    t.index ["occupation_id"], name: "index_units_on_occupation_id"
    t.index ["unit_no"], name: "index_units_on_unit_no", unique: true
    t.index ["zone_id"], name: "index_units_on_zone_id"
  end

  create_table "wood_inventories", id: :serial, force: :cascade do |t|
    t.string "site"
    t.string "unit"
    t.string "strat"
    t.string "strat_other"
    t.string "feature_no"
    t.string "sa_no"
    t.string "salmon_museum_no"
    t.string "storage_location"
    t.string "display"
    t.string "museum_date"
    t.string "grid"
    t.string "quad"
    t.string "depth"
    t.string "record_field_key_no"
    t.string "field_date"
    t.string "lab"
    t.string "analysis"
    t.string "description"
    t.string "select_artifact_info"
  end

  create_table "zones", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "comments"
    t.text "description"
  end

  add_foreign_key "ceramic_claps_features", "ceramic_claps"
  add_foreign_key "ceramic_claps_features", "features"
  add_foreign_key "ceramic_inventories", "features"
  add_foreign_key "ceramic_inventories_features", "ceramic_inventories"
  add_foreign_key "ceramic_inventories_features", "features"
  add_foreign_key "documents_units", "documents"
  add_foreign_key "documents_units", "units"
  add_foreign_key "eggshells", "eggshell_items"
  add_foreign_key "eggshells_features", "eggshells"
  add_foreign_key "eggshells_features", "features"
  add_foreign_key "faunal_inventories", "features"
  add_foreign_key "faunal_inventories_features", "features"
  add_foreign_key "features", "door_between_multiple_rooms"
  add_foreign_key "features", "doorway_sealeds"
  add_foreign_key "features", "feature_groups"
  add_foreign_key "features", "feature_types"
  add_foreign_key "features", "residential_features"
  add_foreign_key "features", "t_shaped_doors"
  add_foreign_key "features_images", "features"
  add_foreign_key "features_images", "images"
  add_foreign_key "features_lithic_debitages", "features"
  add_foreign_key "features_lithic_debitages", "lithic_debitages"
  add_foreign_key "features_lithic_inventories", "features"
  add_foreign_key "features_lithic_inventories", "lithic_inventories"
  add_foreign_key "features_lithic_tools", "features"
  add_foreign_key "features_lithic_tools", "lithic_tools"
  add_foreign_key "features_perishables", "features"
  add_foreign_key "features_perishables", "perishables"
  add_foreign_key "features_pollen_inventories", "features"
  add_foreign_key "features_pollen_inventories", "pollen_inventories"
  add_foreign_key "features_select_artifacts", "features"
  add_foreign_key "features_select_artifacts", "select_artifacts"
  add_foreign_key "features_soils", "features"
  add_foreign_key "features_soils", "soils"
  add_foreign_key "features_strata", "features"
  add_foreign_key "features_strata", "strata"
  add_foreign_key "features_wood_inventories", "features"
  add_foreign_key "features_wood_inventories", "wood_inventories"
  add_foreign_key "image_subjects_images", "image_subjects", column: "image_subjects_id"
  add_foreign_key "image_subjects_images", "images", column: "images_id"
  add_foreign_key "images", "image_boxes"
  add_foreign_key "images", "image_creators"
  add_foreign_key "images", "image_formats"
  add_foreign_key "images", "image_human_remains"
  add_foreign_key "images", "image_orientations"
  add_foreign_key "images", "image_qualities"
  add_foreign_key "lithic_inventories", "features"
  add_foreign_key "ornaments", "features"
  add_foreign_key "soils", "art_types"
  add_foreign_key "strata", "strat_types"
  add_foreign_key "strata", "units"
  add_foreign_key "units", "excavation_statuses"
  add_foreign_key "units", "inferred_functions"
  add_foreign_key "units", "intact_roofs"
  add_foreign_key "units", "irregular_shapes"
  add_foreign_key "units", "salmon_sectors"
  add_foreign_key "units", "stories"
  add_foreign_key "units", "type_descriptions"
  add_foreign_key "units", "unit_classes"
  add_foreign_key "units", "zones"
end

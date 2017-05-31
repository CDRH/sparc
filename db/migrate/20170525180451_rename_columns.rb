class RenameColumns < ActiveRecord::Migration[5.0]

  def change

    # single column tables will now be "name"
    rename_column :art_types, :art_type, :name
    rename_column :bone_tool_occupations, :occupation, :name
    rename_column :door_between_multiple_rooms, :door_between_multiple_rooms, :name
    rename_column :doorway_sealeds, :doorway_sealed, :name
    rename_column :eggshell_affiliations, :affiliation, :name
    rename_column :eggshell_items, :item, :name
    rename_column :excavation_statuses, :excavation_status, :name
    rename_column :feature_groups, :feature_group, :name
    rename_column :feature_occupations, :occupation, :name
    rename_column :feature_types, :feature_type, :name
    rename_column :image_subjects, :subject, :name
    rename_column :inferred_functions, :inferred_function, :name
    rename_column :intact_roofs, :intact_roof, :name
    rename_column :irregular_shapes, :irregular_shape, :name
    rename_column :ornament_periods, :period, :name
    rename_column :perishable_periods, :period, :name
    rename_column :residential_features, :residential_feature, :name
    rename_column :salmon_sectors, :salmon_sector, :name
    rename_column :select_artifact_occupations, :occupation, :name
    rename_column :stories, :story, :name
    rename_column :strat_occupations, :occupation, :name
    rename_column :strat_types, :strat_type, :name
    rename_column :t_shaped_doors, :t_shaped_door, :name
    rename_column :type_descriptions, :type_description, :name
    rename_column :unit_classes, :unit_class, :name
    rename_column :unit_occupations, :occupation, :name
    rename_column :zones, :number, :name

    # bone inventories
    rename_column :bone_inventories, :fs, :fs_no
    rename_column :bone_inventories, :bone_inventory_count, :count
    rename_column :bone_inventories, :gridew, :grid_ew
    rename_column :bone_inventories, :gridns, :grid_ns
    rename_column :bone_inventories, :exactprov, :exact_prov
    rename_column :bone_inventories, :depthbeg, :depth_begin
    rename_column :bone_inventories, :depthend, :depth_end
    rename_column :bone_inventories, :stratalpha, :strat_alpha
    rename_column :bone_inventories, :othstrats, :strat_other
    rename_column :bone_inventories, :sano, :sa_no
    rename_column :bone_inventories, :recordkey, :record_field_key_no
    rename_column :bone_inventories, :entby, :entered_by

    # bone tools
    rename_column :bone_tools, :room, :unit
    rename_column :bone_tools, :field_specimen_no, :fs_no

    # ceramic inventories
    rename_column :ceramic_inventories, :fs, :fs_no
    rename_column :ceramic_inventories, :ceramic_inventory_count, :count
    rename_column :ceramic_inventories, :gridew, :grid_ew
    rename_column :ceramic_inventories, :gridns, :grid_ns
    rename_column :ceramic_inventories, :exactprov, :exact_prov
    rename_column :ceramic_inventories, :depthbeg, :depth_begin
    rename_column :ceramic_inventories, :depthend, :depth_end
    rename_column :ceramic_inventories, :stratalpha, :strat_alpha
    rename_column :ceramic_inventories, :othstrats, :strat_other
    rename_column :ceramic_inventories, :sano, :sa_no
    rename_column :ceramic_inventories, :recordkey, :record_field_key_no
    rename_column :ceramic_inventories, :entby, :entered_by

    # eggshells
    rename_column :eggshells, :room, :unit
    rename_column :eggshells, :salmon_museum_id_no, :salmon_museum_no

    # features
    rename_column :features, :depth_m_b_d, :depth_mbd
    rename_column :features, :feature_count, :count

    # images
    rename_column :images, :room, :unit
    rename_column :images, :asso_features, :associated_features
    rename_column :images, :gride, :grid_ew
    rename_column :images, :gridn, :grid_ns
    rename_column :images, :dep_beg, :depth_begin
    rename_column :images, :dep_end, :depth_end
    rename_column :images, :signi_art_no, :sa_no
    rename_column :images, :data_entry, :entered_by

    # lithic inventories
    rename_column :lithic_inventories, :fs, :fs_no
    rename_column :lithic_inventories, :lithic_inventory_count, :count
    rename_column :lithic_inventories, :gridew, :grid_ew
    rename_column :lithic_inventories, :gridns, :grid_ns
    rename_column :lithic_inventories, :exactprov, :exact_prov
    rename_column :lithic_inventories, :depthbeg, :depth_begin
    rename_column :lithic_inventories, :depthend, :depth_end
    rename_column :lithic_inventories, :stratalpha, :strat_alpha
    rename_column :lithic_inventories, :othstrats, :strat_other
    rename_column :lithic_inventories, :sano, :sa_no
    rename_column :lithic_inventories, :recordkey, :record_field_key_no
    rename_column :lithic_inventories, :entby, :entered_by

    # ornaments
    rename_column :ornaments, :museum_specimen_no, :salmon_museum_no
    rename_column :ornaments, :room, :unit

    # perishables
    rename_column :perishables, :fs_number, :fs_no
    rename_column :perishables, :room, :unit
    rename_column :perishables, :asso_feature, :associated_feature
    rename_column :perishables, :perishable_count, :count
    rename_column :perishables, :other_comments, :comments_other
    rename_column :perishables, :record_key_no, :record_field_key_no

    # select artifacts
    rename_column :select_artifacts, :room, :unit

    # soils
    rename_column :soils, :room, :unit
    rename_column :soils, :fs, :fs_no
    rename_column :soils, :soil_count, :count
    rename_column :soils, :gridew, :grid_ew
    rename_column :soils, :gridns, :grid_ns
    rename_column :soils, :exactprov, :exact_prov
    rename_column :soils, :depthbeg, :depth_begin
    rename_column :soils, :depthend, :depth_end
    rename_column :soils, :otherstrat, :strat_other
    rename_column :soils, :data_entry, :entered_by

    # strata
    # renaming the below to match majority of other tables
    # plus the strata table already has strat_all, strat_alpha, strat_type, etc
    rename_column :strata, :stratum_one, :strat_one
    rename_column :strata, :stratum_two, :strat_two
    rename_column :strata, :stratum_three, :strat_three
  end
end

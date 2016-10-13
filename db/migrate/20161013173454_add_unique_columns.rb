class AddUniqueColumns < ActiveRecord::Migration[5.0]
  def change
    add_index :art_types, :art_type, :unique => true
    change_column :art_types, :art_type, :string, :null => false

    add_index :bone_tool_occupations, :occupation, :unique => true
    change_column :bone_tool_occupations, :occupation, :string, :null => false

    add_index :door_between_multiple_rooms, :door_between_multiple_rooms, :unique => true, :name => "door_between_rooms"
    change_column :door_between_multiple_rooms, :door_between_multiple_rooms, :string, :null => false

    add_index :doorway_sealeds, :doorway_sealed, :unique => true
    change_column :doorway_sealeds, :doorway_sealed, :string, :null => false

    add_index :eggshell_affiliations, :affiliation, :unique => true
    change_column :eggshell_affiliations, :affiliation, :string, :null => false
    
    add_index :eggshell_items, :item, :unique => true
    change_column :eggshell_items, :item, :string, :null => false

    add_index :excavation_statuses, :excavation_status, :unique => true
    change_column :excavation_statuses, :excavation_status, :string, :null => false

    add_index :feature_groups, :feature_group, :unique => true
    change_column :feature_groups, :feature_group, :string, :null => false

    add_index :feature_occupations, :occupation, :unique => true
    change_column :feature_occupations, :occupation, :string, :null => false

    add_index :feature_types, :feature_type, :unique => true
    change_column :feature_types, :feature_type, :string, :null => false

    add_index :inferred_functions, :inferred_function, :unique => true
    change_column :inferred_functions, :inferred_function, :string, :null => false

    add_index :intact_roofs, :intact_roof, :unique => true
    change_column :intact_roofs, :intact_roof, :string, :null => false

    add_index :irregular_shapes, :irregular_shape, :unique => true
    change_column :irregular_shapes, :irregular_shape, :string, :null => false

    add_index :ornament_periods, :period, :unique => true
    change_column :ornament_periods, :period, :string, :null => false

    add_index :perishable_periods, :period, :unique => true
    change_column :perishable_periods, :period, :string, :null => false

    add_index :residentual_features, :residentual_feature, :unique => true
    change_column :residentual_features, :residentual_feature, :string, :null => false

    add_index :salmon_sectors, :salmon_sector, :unique => true
    change_column :salmon_sectors, :salmon_sector, :string, :null => false

    add_index :select_artifact_occupations, :occupation, :unique => true
    change_column :select_artifact_occupations, :occupation, :string, :null => false

    add_index :stories, :story, :unique => true
    change_column :stories, :story, :string, :null => false

    add_index :strat_occupations, :occupation, :unique => true
    change_column :strat_occupations, :occupation, :string, :null => false

    add_index :strat_types, :code, :unique => true
    change_column :strat_types, :code, :string, :null => false

    add_index :t_shaped_doors, :t_shaped_door, :unique => true
    change_column :t_shaped_doors, :t_shaped_door, :string, :null => false

    add_index :type_descriptions, :type_description, :unique => true
    change_column :type_descriptions, :type_description, :string, :null => false

    add_index :unit_classes, :unit_class, :unique => true
    change_column :unit_classes, :unit_class, :string, :null => false

    add_index :unit_occupations, :occupation, :unique => true
    change_column :unit_occupations, :occupation, :string, :null => false

    # possibly most critically, ensuring that unit_no is unique
    add_index :units, :unit_no, :unique => true
    change_column :units, :unit_no, :string, :null => false

  end
end

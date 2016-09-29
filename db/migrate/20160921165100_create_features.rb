class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :unit_no
      t.string :feature_no
      t.string :strat
      t.string :floor_association
      t.string :feature_form
      t.string :other_associated_features
      t.string :grid
      t.string :depth_m_b_d
      t.integer :feature_occupation_id
      t.integer :feature_type_id
      t.integer :feature_count
      t.integer :residentual_feature_id
      t.string :real_feature
      t.string :location_in_room
      t.integer :feature_group_id
      t.integer :doorway_sealed_id
      t.integer :t_shaped_door_id
      t.integer :door_between_multiple_room_id
      t.string :length
      t.string :width
      t.string :depth_height
      t.text :comments

      t.timestamps null: false
    end
    add_foreign_key :features, :feature_occupations
    add_foreign_key :features, :feature_types
    add_foreign_key :features, :feature_groups
    add_foreign_key :features, :residentual_features
    add_foreign_key :features, :doorway_sealeds
    add_foreign_key :features, :t_shaped_doors
    add_foreign_key :features, :door_between_multiple_rooms
    
  end
end

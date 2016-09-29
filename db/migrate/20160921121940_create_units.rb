class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :unit_no
      t.integer :excavation_status_id
      t.integer :unit_occupation_id
      t.integer :unit_class_id
      t.integer :story_id
      t.integer :intact_roof_id
      t.string :salmon_type_code
      t.integer :type_description_id
      t.integer :inferred_function_id
      t.integer :salmon_sector_id
      t.text :other_description
      t.integer :irregular_shape_id
      t.integer :room_type_id
      t.string :length
      t.string :width
      t.string :floor_area
      t.text :comments

      t.timestamps null: false
    end
    add_foreign_key :units, :excavation_statuses
    add_foreign_key :units, :unit_classes
    add_foreign_key :units, :stories
    add_foreign_key :units, :intact_roofs
    add_foreign_key :units, :type_descriptions
    add_foreign_key :units, :inferred_functions
    add_foreign_key :units, :salmon_sectors
    add_foreign_key :units, :irregular_shapes
    add_foreign_key :units, :room_types
  end
end

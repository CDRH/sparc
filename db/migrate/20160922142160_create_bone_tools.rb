class CreateBoneTools < ActiveRecord::Migration
  def change
    create_table :bone_tools do |t|
      t.string :room
      t.string :strat
      t.string :field_specimen_no
      t.string :depth
      t.integer :bone_tool_occupation_id
      t.string :grid
      t.integer :tool_type_code
      t.string :tool_type
      t.integer :species_code
      t.text :comments

      t.timestamps null: false
    end
    add_foreign_key :bone_tools, :bone_tool_occupations
  end
end

class CreateBoneToolOccupations < ActiveRecord::Migration
  def change
    create_table :bone_tool_occupations do |t|
      t.string :occupation

      t.timestamps null: false
    end
  end
end

class CreateBoneToolStrata < ActiveRecord::Migration[5.0]
  def change
    create_join_table :bone_tools, :strata do |t|
      # t.references :bone_tool, index: true, foreign_key: true
      # t.references :stratum, index: true, foreign_key: true
      t.index :bone_tool_id
      t.index :stratum_id
      t.foreign_key :bone_tools
      t.foreign_key :strata
    end
  end
end

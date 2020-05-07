class CreateBoneToolStrata < ActiveRecord::Migration[5.0]
  def change
    create_join_table :bone_tools, :strata do |t|
      t.references :bone_tool, index: true, foreign_key: true
      t.references :stratum, index: true, foreign_key: true
    end
  end
end

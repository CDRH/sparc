class CreateJoinTableBoneToolFeature < ActiveRecord::Migration[5.0]
  def change
    create_join_table :bone_tools, :features do |t|
      t.references :bone_tool, index: true, foreign_key: true
      t.references :feature, index: true, foreign_key: true
    end
  end
end

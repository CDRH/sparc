class CreateJoinTableBoneToolFeature < ActiveRecord::Migration[5.0]
  def change
    create_join_table :bone_tools, :features do |t|
      #t.references :bone_tool, index: true, foreign_key: true
      #t.references :feature, index: true, foreign_key: true
      t.index :bone_tool_id
      t.index :feature_id
      t.foreign_key :bone_tools
      t.foreign_key :features
    end
  end
end

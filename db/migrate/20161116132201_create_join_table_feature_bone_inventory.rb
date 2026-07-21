class CreateJoinTableFeatureBoneInventory < ActiveRecord::Migration[5.0]
  def change
    create_join_table :features, :bone_inventories do |t|
      # t.references :feature, index: true, foreign_key: true
      # t.references :bone_inventory, index: true, foreign_key: true
      t.index :feature_id
      t.index :bone_inventory_id
      t.foreign_key :features
      t.foreign_key :bone_inventories
    end
  end
end

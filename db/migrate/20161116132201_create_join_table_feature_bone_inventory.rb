class CreateJoinTableFeatureBoneInventory < ActiveRecord::Migration[5.0]
  def change
    create_join_table :features, :bone_inventories do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :bone_inventory, index: true, foreign_key: true
    end
  end
end

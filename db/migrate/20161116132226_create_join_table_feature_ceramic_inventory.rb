class CreateJoinTableFeatureCeramicInventory < ActiveRecord::Migration[5.0]
  def change
    create_join_table :features, :ceramic_inventories do |t|
      # t.references :feature, index: true, foreign_key: true
      # t.references :ceramic_inventory, index: true, foreign_key: true
      t.index :feature_id
      t.index :ceramic_inventory_id
      t.foreign_key :features
      t.foreign_key :ceramic_inventories
    end
  end
end

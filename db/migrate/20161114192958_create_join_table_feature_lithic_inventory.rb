class CreateJoinTableFeatureLithicInventory < ActiveRecord::Migration[5.0]
  def change
    create_join_table :lithic_inventories, :features do |t|
      # t.references :feature, index: true, foreign_key: true
      # t.references :lithic_inventory, index: true, foreign_key: true
      t.index :lithic_inventory_id
      t.index :feature_id
      t.foreign_key :lithic_inventories
      t.foreign_key :features
    end
  end
end

class CreateJoinTableFeatureLithicInventory < ActiveRecord::Migration[5.0]
  def change
    create_join_table :lithic_inventories, :features do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :lithic_inventory, index: true, foreign_key: true
    end
  end
end

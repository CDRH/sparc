class CreateJoinTableFeatureCeramicInventory < ActiveRecord::Migration[5.0]
  def change
    create_join_table :features, :ceramic_inventories do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :ceramic_inventory, index: true, foreign_key: true
    end
  end
end

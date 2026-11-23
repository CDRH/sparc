class CreateWoodInventory < ActiveRecord::Migration[5.0]
  def change
    create_table :wood_inventories do |t|
      t.string :site
      t.string :unit
      t.string :strat
      t.string :strat_other
      t.string :feature_no
      t.string :sa_no
      t.string :salmon_museum_no
      t.string :storage_location
      t.string :display
      t.string :museum_date
      t.string :grid
      t.string :quad
      t.string :depth
      t.string :record_field_key_no
      t.string :field_date
      t.string :lab
      t.string :analysis
      t.string :description
    end

    create_join_table :wood_inventories, :features do |t|
      t.index :wood_inventory_id
      t.index :feature_id
      t.foreign_key :wood_inventories
      t.foreign_key :features
      # t.references :wood_inventory, index: true, foreign_key: true
      # t.references :feature, index: true, foreign_key: true
    end
  end
end

class CreateLithicInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :lithic_inventories do |t|
      t.string :site
      t.string :box
      t.string :fs
      t.integer :lithic_inventory_count
      t.string :gridew
      t.string :gridns
      t.string :quad
      t.string :exactprov
      t.string :depthbeg
      t.string :depthend
      t.string :stratalpha
      t.integer :strat_one
      t.integer :strat_two
      t.string :othstrats
      t.string :field_date
      t.string :excavator
      t.string :art_type
      t.string :sano
      t.string :recordkey
      t.integer :feature_id
      t.text :comments
      t.string :entby
      t.string :location

      t.timestamps
    end
    add_foreign_key :lithic_inventories, :features
    
  end
end

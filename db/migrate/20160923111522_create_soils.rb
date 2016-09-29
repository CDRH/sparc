class CreateSoils < ActiveRecord::Migration[5.0]
  def change
    create_table :soils do |t|
      t.string :site
      t.string :room
      t.string :strat
      t.string :feature_key
      t.string :fs
      t.string :box
      t.string :period
      t.integer :soil_count
      t.string :gridew
      t.string :gridns
      t.string :quad
      t.string :exactprov
      t.string :depthbeg
      t.string :depthend
      t.string :otherstrat
      t.string :date
      t.string :excavator
      t.integer :art_type_id
      t.string :sample_no
      t.text :comments
      t.text :data_entry
      t.string :location

      t.timestamps
    end
    add_foreign_key :soils, :art_types
  end
end

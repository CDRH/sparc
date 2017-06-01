class CreatePollenInventory < ActiveRecord::Migration[5.0]
  def change
    create_table :pollen_inventories do |t|
      t.string :unit
      t.string :strat
      t.string :strat_other
      t.string :salmon_museum_no
      t.string :sa_no
      t.string :grid
      t.string :quad
      t.string :depth
      t.string :box
      t.string :record_field_key_no
      t.string :other_sample_no
      t.string :date
      t.string :analysis_completed
      t.string :frequency
    end

    create_join_table :pollen_inventories, :features do |t|
      t.references :pollen_inventory, index: true, foreign_key: true
      t.references :feature, index: true, foreign_key: true
    end
  end
end

class CreateEggshells < ActiveRecord::Migration
  def change
    create_table :eggshells do |t|
      t.integer :stratum_id
      t.string :room
      t.string :strat
      t.string :salmon_museum_id_no
      t.string :record_field_key_no
      t.string :grid
      t.string :quad
      t.string :depth
      t.string :feature_no
      t.string :storage_bin
      t.string :museum_date
      t.string :field_date
      t.integer :eggshell_affiliation_id
      t.integer :eggshell_item_id

      t.timestamps null: false
    end
    add_foreign_key :eggshells, :eggshell_affiliations
    add_foreign_key :eggshells, :eggshell_items
  end
end

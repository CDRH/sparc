class CreateOrnaments < ActiveRecord::Migration[5.0]
  def change
    create_table :ornaments do |t|
      t.string :museum_specimen_no
      t.string :analysis_lab_no
      t.string :room
      t.string :strat
      t.string :grid
      t.string :quad
      t.string :depth
      t.string :field_date
      t.integer :ornament_period_id
      t.integer :feature_id
      t.string :analyst
      t.string :analyzed
      t.string :photographer
      t.integer :count
      t.string :item

      t.timestamps
    end
    add_foreign_key :ornaments, :ornament_periods
    add_foreign_key :ornaments, :features
  end
end

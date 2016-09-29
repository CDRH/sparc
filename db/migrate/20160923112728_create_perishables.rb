class CreatePerishables < ActiveRecord::Migration[5.0]
  def change
    create_table :perishables do |t|
      t.string :fs_number
      t.string :salmon_museum_number
      t.string :room
      t.string :strat
      t.string :grid
      t.string :quad
      t.string :depth
      t.string :asso_feature
      t.integer :perishable_period_id
      t.string :sa_no
      t.string :artifact_type
      t.integer :perishable_count
      t.string :artifact_structure
      t.text :comments
      t.text :other_comments
      t.string :storage_location
      t.string :object_structure
      t.string :exhibit_location
      t.string :record_key_no
      t.string :museum_lab_no
      t.string :field_date
      t.text :original_analysis

      t.timestamps
    end
    add_foreign_key :perishables, :perishable_periods
  end
end

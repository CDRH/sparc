class CreateLithicDebitages < ActiveRecord::Migration[5.0]
  def change
    create_table :lithic_debitages do |t|
      t.string :unit
      t.string :fs_no
      t.string :artifact_no
      t.string :artifact_type
      t.string :fire_altered
      t.string :utilized
      t.integer :cortex_percentage
      t.integer :cortical_flakes
      t.integer :non_cortical_flakes
      t.decimal :length
      t.decimal :width
      t.decimal :thickness
      t.decimal :weight
      t.string :comments
      t.integer :total_flakes_in_bag
    end

    create_join_table :lithic_debitages, :features do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :lithic_debitage, index: true, foreign_key: true
    end

    add_reference :lithic_debitages, :lithic_inventory
    add_reference :lithic_debitages, :lithic_material_type
    add_reference :lithic_debitages, :lithic_condition
    add_reference :lithic_debitages, :lithic_platform_type
    add_reference :lithic_debitages, :lithic_termination
  end
end

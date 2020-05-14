class CreateStrata < ActiveRecord::Migration[5.0]
  def change
    create_table :strata do |t|
      t.integer :unit_id
      t.string :strat_all
      t.string :strat_alpha
      t.integer :strat_type_id
      t.string :stratum_one
      t.string :stratum_two
      t.string :stratum_three
      t.integer :strat_occupation_id
      t.text :comments

      t.timestamps null: false
    end
    add_foreign_key :strata, :units
    add_foreign_key :strata, :strat_types
    add_foreign_key :strata, :strat_occupations
  end
end

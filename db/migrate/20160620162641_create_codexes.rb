class CreateCodexes < ActiveRecord::Migration
  def change
    create_table :codexes do |t|
      t.string :room_no
      t.string :unit_type
      t.string :strat_all
      t.string :strat_alpha
      t.string :stratum_one
      t.string :straum_two
      t.string :alias_strats
      t.string :original_period
      t.string :dominant_occupation
      t.string :stratum_two
      t.text :comments
      t.integer :room_id

      t.timestamps null: false
    end
  end
end

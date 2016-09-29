class CreateStratTypes < ActiveRecord::Migration
  def change
    create_table :strat_types do |t|
      t.string :code
      t.string :strat_type

      t.timestamps null: false
    end
  end
end

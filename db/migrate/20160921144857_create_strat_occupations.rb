class CreateStratOccupations < ActiveRecord::Migration
  def change
    create_table :strat_occupations do |t|
      t.string :occupation

      t.timestamps null: false
    end
  end
end

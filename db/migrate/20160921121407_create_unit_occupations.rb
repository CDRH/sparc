class CreateUnitOccupations < ActiveRecord::Migration
  def change
    create_table :unit_occupations do |t|
      t.string :occupation

      t.timestamps null: false
    end
  end
end

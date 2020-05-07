class CreateUnitOccupations < ActiveRecord::Migration[5.0]
  def change
    create_table :unit_occupations do |t|
      t.string :occupation

      t.timestamps null: false
    end
  end
end

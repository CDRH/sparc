class CondenseOccupation < ActiveRecord::Migration[5.0]
  def change
    # remove unused columns
    remove_column :units, :unit_occupation_id, :integer
    remove_column :soils, :period, :string

    # remove soon to be defunct period on room_types
    remove_column :room_types, :period, :string

    # remove indexes for occupations / periods
    remove_reference :perishables, :perishable_period, index: true, foreign_key: true

    # drop the period table
    drop_table :perishable_periods do |t|
      t.string :name, null: false
      t.timestamps
    end

    # add new references to occupations table
    add_reference :perishables, :occupation
    add_reference :room_types, :occupation
  end
end

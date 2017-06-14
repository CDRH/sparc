class CreateStrataGrouping < ActiveRecord::Migration[5.0]
  def change
    # naming it "strat" to fit with the "strat_types" table naming
    create_table :strat_groupings do |t|
      t.string :name
      t.timestamps
    end

    add_reference :strat_types, :strat_grouping
  end
end

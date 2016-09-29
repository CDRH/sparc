class CreatePerishablePeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :perishable_periods do |t|
      t.string :period

      t.timestamps
    end
  end
end

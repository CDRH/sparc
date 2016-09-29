class CreateOrnamentPeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :ornament_periods do |t|
      t.string :period

      t.timestamps
    end
  end
end

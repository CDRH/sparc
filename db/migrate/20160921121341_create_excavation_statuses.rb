class CreateExcavationStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :excavation_statuses do |t|
      t.string :excavation_status

      t.timestamps null: false
    end
  end
end

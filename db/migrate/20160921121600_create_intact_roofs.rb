class CreateIntactRoofs < ActiveRecord::Migration[5.0]
  def change
    create_table :intact_roofs do |t|
      t.string :intact_roof

      t.timestamps null: false
    end
  end
end

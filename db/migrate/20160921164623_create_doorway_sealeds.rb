class CreateDoorwaySealeds < ActiveRecord::Migration[5.0]
  def change
    create_table :doorway_sealeds do |t|
      t.string :doorway_sealed

      t.timestamps null: false
    end
  end
end

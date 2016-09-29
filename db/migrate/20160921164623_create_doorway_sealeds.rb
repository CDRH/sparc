class CreateDoorwaySealeds < ActiveRecord::Migration
  def change
    create_table :doorway_sealeds do |t|
      t.string :doorway_sealed

      t.timestamps null: false
    end
  end
end

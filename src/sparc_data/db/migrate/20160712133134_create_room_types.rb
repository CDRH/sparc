class CreateRoomTypes < ActiveRecord::Migration
  def change
    create_table :room_types do |t|
      t.string :description
      t.string :period
      t.string :location

      t.timestamps null: false
    end
  end
end

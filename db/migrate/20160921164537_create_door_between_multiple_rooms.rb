class CreateDoorBetweenMultipleRooms < ActiveRecord::Migration
  def change
    create_table :door_between_multiple_rooms do |t|
      t.string :door_between_multiple_rooms

      t.timestamps null: false
    end
  end
end

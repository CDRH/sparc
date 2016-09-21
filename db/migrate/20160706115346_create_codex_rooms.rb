class CreateCodexRooms < ActiveRecord::Migration
  def change
    create_table :codex_rooms do |t|
      t.integer :codex_id
      t.integer :room_id

      t.timestamps null: false
    end
  end
end

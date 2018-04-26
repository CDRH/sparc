class RemoveRoomType < ActiveRecord::Migration[5.0]
  def change
    remove_reference :units, :room_type, index: true, foreign_key: true
    remove_reference :room_types, :occupation
    drop_table :room_types do |t|
      t.string :description
      t.string :location
      t.timestamps
    end
  end
end

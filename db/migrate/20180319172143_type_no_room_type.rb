class TypeNoRoomType < ActiveRecord::Migration[5.0]
  def change
    add_column :room_types, :type_no, :string
  end
end

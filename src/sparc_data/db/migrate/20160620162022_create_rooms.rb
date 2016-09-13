class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :room_no
      t.string :excavation_status
      t.string :occupation
      t.string :room_class
      t.string :stories
      t.string :intact_roof
      t.integer :room_type_id
      t.string :type_description
      t.string :inferred_function
      t.string :salmon_sector
      t.text :other_desc
      t.string :irregular_shape
      t.string :length_text
      t.string :width_text
      t.string :floor_area_text
      t.text :comments

      t.timestamps null: false
    end
  end
end

class AddFieldsToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :t_shaped_door, :string
    add_column :features, :door_between_multiple_rooms, :string
    add_column :features, :doorway_sealed, :string
    add_column :features, :length_text, :string
    add_column :features, :width_text, :string
    add_column :features, :depth_height_text, :string
  end
end

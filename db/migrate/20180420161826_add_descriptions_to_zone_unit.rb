class AddDescriptionsToZoneUnit < ActiveRecord::Migration[5.0]
  def change
    add_column :zones, :description, :text
    add_column :units, :description, :text
  end
end

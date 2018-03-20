class ChangeFaunaltoolToBonetool < ActiveRecord::Migration[5.0]
  def change
    rename_table :faunal_tools, :bone_tools
  end
end

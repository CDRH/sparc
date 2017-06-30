class RenameBonesToFaunal < ActiveRecord::Migration[5.0]
  def change
    # inventories
    rename_table :bone_inventories, :faunal_inventories
    rename_table :bone_inventories_features, :faunal_inventories_features
    remove_reference :faunal_inventories_features, :bone_inventory
    add_reference :faunal_inventories_features, :faunal_inventory

    # tools
    rename_table :bone_tools, :faunal_tools
    rename_table :bone_tools_strata, :faunal_tools_strata
    remove_reference :faunal_tools_strata, :bone_tool
    add_reference :faunal_tools_strata, :faunal_tool
    remove_reference :faunal_tools, :bone_inventory
    add_reference :faunal_tools, :faunal_inventory
  end
end

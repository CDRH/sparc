class AnalysisToInventories < ActiveRecord::Migration[5.0]
  def change
    # add column to analysis tables that references inventory tables
    add_reference :bone_tools, :bone_inventory
    add_reference :ceramics, :ceramic_inventory
    add_reference :ceramic_vessels, :ceramic_inventory
  end
end

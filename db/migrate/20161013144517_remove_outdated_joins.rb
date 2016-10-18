class RemoveOutdatedJoins < ActiveRecord::Migration[5.0]
  def change
    drop_join_table :bone_tools, :features
    drop_join_table :eggshells, :strata
    drop_join_table :select_artifacts, :features
    drop_join_table :ornaments, :strata
    drop_join_table :soils, :strata
  end
end

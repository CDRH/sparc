class RemoveStratumIdFromEggshells < ActiveRecord::Migration[5.0]
  def change
    remove_column :eggshells, :stratum_id, :integer
  end
end

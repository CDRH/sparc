class RemoveObjectStructureFromPerishables < ActiveRecord::Migration[5.0]
  def change
    remove_column :perishables, :object_structure, :string
  end
end

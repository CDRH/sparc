class RemovePiiFromLithicTools < ActiveRecord::Migration[5.0]
  def change
    remove_column :lithic_tools, :pii, :string
  end
end

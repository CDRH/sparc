class AddFieldToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :strat_other, :string
  end
end

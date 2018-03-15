class AddCodeToUnitClass < ActiveRecord::Migration[5.0]
  def change
    add_column :unit_classes, :code, :string, default: ""
  end
end

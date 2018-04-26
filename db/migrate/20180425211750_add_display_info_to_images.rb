class AddDisplayInfoToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :file_exists, :boolean
  end
end

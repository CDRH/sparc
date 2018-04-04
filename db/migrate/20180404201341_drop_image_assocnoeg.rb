class DropImageAssocnoeg < ActiveRecord::Migration[5.0]
  def change
    remove_column :images, :image_type, :string
    remove_reference :images, :image_assocnoeg, index: true, foreign_key: true
    drop_table :image_assocnoegs do |t|
      t.string :name
      t.timestamps
    end
  end
end

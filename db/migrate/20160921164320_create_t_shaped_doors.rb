class CreateTShapedDoors < ActiveRecord::Migration[5.0]
  def change
    create_table :t_shaped_doors do |t|
      t.string :t_shaped_door

      t.timestamps null: false
    end
  end
end

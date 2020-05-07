class CreateIrregularShapes < ActiveRecord::Migration[5.0]
  def change
    create_table :irregular_shapes do |t|
      t.string :irregular_shape

      t.timestamps null: false
    end
  end
end

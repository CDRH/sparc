class CreateUnitClasses < ActiveRecord::Migration[5.0]
  def change
    create_table :unit_classes do |t|
      t.string :unit_class

      t.timestamps null: false
    end
  end
end

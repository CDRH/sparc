class CreateUnitClasses < ActiveRecord::Migration
  def change
    create_table :unit_classes do |t|
      t.string :unit_class

      t.timestamps null: false
    end
  end
end

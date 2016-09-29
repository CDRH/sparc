class CreateTypeDescriptions < ActiveRecord::Migration
  def change
    create_table :type_descriptions do |t|
      t.string :type_description

      t.timestamps null: false
    end
  end
end

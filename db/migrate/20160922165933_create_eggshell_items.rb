class CreateEggshellItems < ActiveRecord::Migration[5.0]
  def change
    create_table :eggshell_items do |t|
      t.string :item

      t.timestamps
    end
  end
end

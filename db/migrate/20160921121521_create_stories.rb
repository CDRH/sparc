class CreateStories < ActiveRecord::Migration[5.0]
  def change
    create_table :stories do |t|
      t.string :story

      t.timestamps null: false
    end
  end
end

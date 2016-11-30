class CreateZones < ActiveRecord::Migration[5.0]
  def change
    create_table :zones do |t|
      t.string :number
      t.text :comments
    end

    add_reference :units, :zone, index: true, foreign_key: true
  end
end

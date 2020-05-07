class CreateSalmonSectors < ActiveRecord::Migration[5.0]
  def change
    create_table :salmon_sectors do |t|
      t.string :salmon_sector

      t.timestamps null: false
    end
  end
end

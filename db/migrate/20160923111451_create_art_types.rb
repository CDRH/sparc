class CreateArtTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :art_types do |t|
      t.string :art_type

      t.timestamps
    end
  end
end

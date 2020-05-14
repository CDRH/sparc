class CreateFeatureTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :feature_types do |t|
      t.string :feature_type

      t.timestamps null: false
    end
  end
end

class CreateFeatureOccupations < ActiveRecord::Migration
  def change
    create_table :feature_occupations do |t|
      t.string :occupation

      t.timestamps null: false
    end
  end
end

class CreateFeatureGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :feature_groups do |t|
      t.string :feature_group

      t.timestamps null: false
    end
  end
end

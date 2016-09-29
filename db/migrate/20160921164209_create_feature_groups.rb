class CreateFeatureGroups < ActiveRecord::Migration
  def change
    create_table :feature_groups do |t|
      t.string :feature_group

      t.timestamps null: false
    end
  end
end

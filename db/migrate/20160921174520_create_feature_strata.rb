class CreateFeatureStrata < ActiveRecord::Migration[5.0]
  def change
    create_join_table :features, :strata do |t|
      t.index :feature_id
      t.index :stratum_id
      t.foreign_key :features
      t.foreign_key :strata
    end
  end
end

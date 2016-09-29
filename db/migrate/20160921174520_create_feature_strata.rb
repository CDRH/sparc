class CreateFeatureStrata < ActiveRecord::Migration
  def change
    create_join_table :features, :strata do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :stratum, index: true, foreign_key: true
    end
  end
end

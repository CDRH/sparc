class CreateJoinTableSoilStratum < ActiveRecord::Migration[5.0]
  def change
    create_join_table :soils, :strata do |t|
      # t.references :soil, index: true, foreign_key: true
      # t.references :stratum, index: true, foreign_key: true
      t.index :soil_id
      t.index :stratum_id
      t.foreign_key :soils
      t.foreign_key :strata
    end
  end
end

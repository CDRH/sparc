class CreateJoinTableSoilStratum < ActiveRecord::Migration[5.0]
  def change
    create_join_table :soils, :strata do |t|
      t.references :soil, index: true, foreign_key: true
      t.references :stratum, index: true, foreign_key: true
    end
  end
end

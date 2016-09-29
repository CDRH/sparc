class CreateJoinTableFeatureSoil < ActiveRecord::Migration[5.0]
  def change
    create_join_table :soils, :features do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :soil, index: true, foreign_key: true
    end
  end
end

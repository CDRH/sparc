class CreateJoinTableFeaturePerishable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :perishables, :features do |t|
      # t.references :feature, index: true, foreign_key: true
      # t.references :perishable, index: true, foreign_key: true
      t.index :perishable_id
      t.index :feature_id
      t.foreign_key :perishables
      t.foreign_key :features
    end
  end
end

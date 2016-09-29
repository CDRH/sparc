class CreateJoinTableFeaturePerishable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :perishables, :features do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :perishable, index: true, foreign_key: true
    end
  end
end

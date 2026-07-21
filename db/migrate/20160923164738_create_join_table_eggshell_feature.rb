class CreateJoinTableEggshellFeature < ActiveRecord::Migration[5.0]
  def change
    create_join_table :eggshells, :features do |t|
      # t.references :feature, index: true, foreign_key: true
      # t.references :eggshell, index: true, foreign_key: true
      t.index :feature_id
      t.index :eggshell_id
      t.foreign_key :features
      t.foreign_key :eggshells
    end
  end
end

class CreateJoinTableEggshellFeature < ActiveRecord::Migration[5.0]
  def change
    create_join_table :eggshells, :features do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :eggshell, index: true, foreign_key: true
    end
  end
end

class CreateJoinTableEggshellStrata < ActiveRecord::Migration[5.0]
  def change
    create_join_table :eggshells, :strata do |t|
      t.references :eggshell, index: true, foreign_key: true
      t.references :stratum, index: true, foreign_key: true
    end
  end
end

class CreateJoinTableOrnamentStratum < ActiveRecord::Migration[5.0]
  def change
    create_join_table :ornaments, :strata do |t|
      # t.references :ornament, index: true, foreign_key: true
      # t.references :stratum, index: true, foreign_key: true
      t.index :ornament_id
      t.index :stratum_id
      t.foreign_key :ornaments
      t.foreign_key :strata
    end
  end
end

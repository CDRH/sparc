class CreateJoinTableSelectArtifactStratum < ActiveRecord::Migration[5.0]
  def change
    create_join_table :select_artifacts, :strata do |t|
      # t.references :stratum, index: true, foreign_key: true
      # t.references :select_artifact, index: true, foreign_key: true
      t.index :select_artifact_id
      t.index :stratum_id
      t.foreign_key :select_artifacts
      t.foreign_key :strata
    end
  end
end

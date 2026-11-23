class CreateJoinTableFeatureSelectArtifact < ActiveRecord::Migration[5.0]
  def change
    create_join_table :select_artifacts, :features do |t|
      #t.references :feature, index: true, foreign_key: true
      #t.references :select_artifact, index: true, foreign_key: true
      t.index :select_artifact_id
      t.index :feature_id
      t.foreign_key :select_artifacts
      t.foreign_key :features
    end
  end
end

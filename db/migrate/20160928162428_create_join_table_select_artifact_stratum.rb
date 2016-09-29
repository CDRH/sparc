class CreateJoinTableSelectArtifactStratum < ActiveRecord::Migration[5.0]
  def change
    create_join_table :select_artifacts, :strata do |t|
      t.references :stratum, index: true, foreign_key: true
      t.references :select_artifact, index: true, foreign_key: true
    end
  end
end

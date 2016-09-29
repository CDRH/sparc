class CreateSelectArtifacts < ActiveRecord::Migration[5.0]
  def change
    create_table :select_artifacts do |t|
      t.string :room
      t.string :artifact_no
      t.string :strat
      t.string :floor_association
      t.string :sa_form
      t.string :associated_feature_artifacts
      t.string :grid
      t.string :depth
      t.integer :select_artifact_occupation_id
      t.string :select_artifact_type
      t.string :artifact_count
      t.string :location_in_room
      t.text :comments

      t.timestamps
    end
    add_foreign_key :select_artifacts, :select_artifact_occupations
  end
end

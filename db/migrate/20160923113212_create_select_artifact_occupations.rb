class CreateSelectArtifactOccupations < ActiveRecord::Migration[5.0]
  def change
    create_table :select_artifact_occupations do |t|
      t.string :occupation

      t.timestamps
    end
  end
end

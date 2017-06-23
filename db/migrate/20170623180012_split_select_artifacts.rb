class SplitSelectArtifacts < ActiveRecord::Migration[5.0]
  def change

    # SELECT ARTIFACTS

    # associate with features, not strata
    drop_join_table :select_artifacts, :strata

    create_join_table :select_artifacts, :features do |t|
      t.references :select_artifact, index: true, foreign_key: true
      t.references :feature, index: true, foreign_key: true
    end

    # match naming convention used elsewhere
    rename_column :select_artifacts, :artifact_no, :sa_no

    add_column :select_artifacts, :feature_no, :string
    # I decided against trying to join SA to each table in some way
    # because some of them have multiple SA #, etc
    # so just noting which table it was added to in case lookup needed later
    add_column :select_artifacts, :appears_in_table, :string
    add_column :select_artifacts, :strat_other, :string

    # OTHER TABLES

    # ornaments was not previously storing the sa_no
    add_column :ornaments, :sa_no, :string
    add_column :ornaments, :strat_other, :string

    add_column :bone_inventories, :select_artifact_info, :string
    add_column :ceramic_inventories, :select_artifact_info, :string
    add_column :lithic_inventories, :select_artifact_info, :string
    add_column :ornaments, :select_artifact_info, :string
    add_column :perishables, :select_artifact_info, :string
    add_column :ceramic_vessels, :select_artifact_info, :string
    add_column :wood_inventories, :select_artifact_info, :string
  end
end

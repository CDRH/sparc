class CreateOccupations < ActiveRecord::Migration[5.0]
  def change

    # NOTE: NOT dropping perishables periods because there
    # are too many and there is not a lot of overlap with other occupations

    # rename
    rename_table :unit_occupations, :occupations

    # remove all the indexes for occupations / periods
    remove_reference :bone_tools, :bone_tool_occupations, index: true, foreign_key: true
    remove_reference :eggshells, :eggshell_affiliation, index: true, foreign_key: true
    remove_reference :features, :feature_occupation, index: true, foreign_key: true
    remove_reference :ornaments, :ornament_period, index: true, foreign_key: true
    remove_reference :select_artifacts, :select_artifact_occupation, index: true, foreign_key: true
    remove_reference :strata, :strat_occupation, index: true, foreign_key: true

    # also kill a column that doesn't seem to be getting used?
    remove_column :bone_tools, :bone_tool_occupation_id, :integer

    # start dropping the tables
    drop_table :bone_tool_occupations do |t|
      t.string :name, null: false
      t.timestamps
    end
    drop_table :eggshell_affiliations do |t|
      t.string :name, null: false
      t.timestamps
    end
    drop_table :feature_occupations do |t|
      t.string :name, null: false
      t.timestamps
    end
    drop_table :ornament_periods do |t|
      t.string :name, null: false
      t.timestamps
    end
    drop_table :select_artifact_occupations do |t|
      t.string :name, null: false
      t.timestamps
    end
    drop_table :strat_occupations do |t|
      t.string :name, null: false
      t.timestamps
    end

    # add new references to occupations table
    add_reference :bone_tools, :occupation
    add_reference :eggshells, :occupation
    add_reference :features, :occupation
    add_reference :ornaments, :occupation
    add_reference :select_artifacts, :occupation
    add_reference :strata, :occupation
    add_reference :units, :occupation

  end
end

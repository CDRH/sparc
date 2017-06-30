class FaunalToolToFeature < ActiveRecord::Migration[5.0]
  def change
    # change faunal tools association from strata to single feature
    drop_join_table :faunal_tools, :strata
    add_reference :faunal_tools, :feature

    # add several other fields which now exist in spreadsheet
    add_column :faunal_tools, :strat_other, :string
    add_column :faunal_tools, :sa_no, :string
  end
end

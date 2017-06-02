class Createtreerings < ActiveRecord::Migration[5.0]
  def change
    create_table :tree_rings do |t|
      t.string :site
      t.string :unit_no
      t.string :record_field_key_no
      t.string :strat
      # NOTE: instructions say not to associate features
      # for tree rings at this point in time, but adding to DB field
      # in case future spreadsheet update adds any values to this column
      # That way we won't have to recognize the change and potential values
      # will at least be stored as strings in the DB
      t.string :feature_no
      t.string :trl_no
      t.string :year_dated
      t.string :windes_sample
      t.string :field_no
      t.string :inner_date
      t.string :outer_date
      t.string :symbol
      t.string :cutting_date
      t.string :comments
    end

    # NOTE: to avoid confusion between singular and plural
    # species, I'm inverting the naming convention we've been using
    create_table :species_tree_rings do |t|
      t.string :name
      t.timestamps
    end

    add_reference :tree_rings, :stratum
    add_reference :tree_rings, :occupation
    add_reference :tree_rings, :species_tree_ring
  end
end

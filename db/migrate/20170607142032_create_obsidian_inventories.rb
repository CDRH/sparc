class CreateObsidianInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :obsidian_inventories do |t|
      t.string :site
      t.string :box
      t.string :fs_no
      t.string :count
      t.string :unit
      t.string :strat
      t.string :strat_other
      t.string :feature_no
      t.string :lithic_id
      t.integer :count
      t.string :material_type
      t.string :shackley_sourcing
      t.string :grid_ew
      t.string :grid_ns
      t.string :quad
      t.string :exact_prov
      t.string :artifact_type
      t.string :depth_begin
      t.string :depth_end
      t.string :date
      t.string :excavator
      t.string :record_field_key_no
      t.string :comments
      t.string :entered_by
      t.string :location
      t.timestamps
    end

    create_table :obsidian_identified_sources do |t|
      t.string :name
      t.timestamps
    end

    add_reference :obsidian_inventories, :obsidian_identified_source
    # only one feature per obsidian inv
    add_reference :obsidian_inventories, :feature
    add_reference :obsidian_inventories, :occupation
  end
end

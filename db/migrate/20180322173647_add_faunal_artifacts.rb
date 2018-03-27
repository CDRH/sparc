class AddFaunalArtifacts < ActiveRecord::Migration[5.0]
  def change
    create_table :faunal_artifacts do |t|
      t.string :fs_no
      t.string :artifact_no
      t.string :unit
      t.string :strat
      t.string :feature_no
      t.string :grid_ew
      t.string :grid_ns
      t.string :depth_begin
      t.string :depth_end
      t.string :spc
      t.string :elem
      t.string :side
      t.string :cond
      t.string :frag
      t.string :pd
      t.string :dv
      t.string :fuse
      t.string :burn
      t.string :art
      t.string :gnaw
      t.string :mod
      t.string :bmark
      t.string :frags

      t.timestamps
    end
    add_reference :faunal_artifacts, :faunal_inventory
    add_reference :faunal_artifacts, :feature
  end
end

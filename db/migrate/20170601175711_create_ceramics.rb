class CreateCeramics < ActiveRecord::Migration[5.0]
  def change

    # primary ceramics (2005) table
    create_table :ceramics do |t|
      t.string :site
      t.string :fs_no
      t.integer :lot_no
      t.integer :cat_no
      t.string :unit
      t.string :strat
      t.string :feature_no
      t.string :sa_no
      t.string :pulled_sample
      t.decimal :wall_thickness
      t.decimal :rim_radius
      t.integer :rim_arc
      t.integer :rim_eversion
      t.string :residues
      t.string :modification
      t.integer :count
      t.decimal :weight
      t.string :vessel_no
      t.string :comments
      t.timestamps
    end

    create_table :ceramic_vessel_forms do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_vessel_parts do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_exterior_pigments do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_interior_pigments do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_exterior_surfaces do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_interior_surfaces do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_vessel_appendages do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_tempers do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_pastes do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_slips do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_traditions do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_varieties do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_wares do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_specific_types do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_styles do |t|
      t.string :name
      t.timestamps
    end

    # only one feature per ceramic
    add_reference :ceramics, :feature
    add_reference :ceramics, :ceramic_vessel_form
    add_reference :ceramics, :ceramic_vessel_part
    add_reference :ceramics, :ceramic_exterior_pigment
    add_reference :ceramics, :ceramic_interior_pigment
    add_reference :ceramics, :ceramic_exterior_surface
    add_reference :ceramics, :ceramic_interior_surface
    add_reference :ceramics, :ceramic_vessel_appendage
    add_reference :ceramics, :ceramic_temper
    add_reference :ceramics, :ceramic_paste
    add_reference :ceramics, :ceramic_slip
    add_reference :ceramics, :ceramic_tradition
    add_reference :ceramics, :ceramic_variety
    add_reference :ceramics, :ceramic_ware
    add_reference :ceramics, :ceramic_specific_type
    add_reference :ceramics, :ceramic_style
  end
end

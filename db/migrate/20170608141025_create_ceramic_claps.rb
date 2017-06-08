class CreateCeramicClaps < ActiveRecord::Migration[5.0]
  def change
    create_table :ceramic_claps do |t|
      t.string :unit
      t.string :strat
      t.string :feature_no
      t.string :record_field_key_no
      t.string :grid
      t.string :depth_begin
      t.string :depth_end
      t.string :field_year
      t.integer :sherd_lot_no
      t.string :frequency
      t.string :comments
      t.timestamps
    end

    create_join_table :ceramic_claps, :features do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :ceramic_clap, index: true, foreign_key: true
    end

    create_table :ceramic_clap_types do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_clap_group_types do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_clap_traditions do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_clap_vessel_forms do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_clap_tempers do |t|
      t.string :name
      t.timestamps
    end

    add_reference :ceramic_claps, :ceramic_clap_type
    add_reference :ceramic_claps, :ceramic_clap_group_type
    add_reference :ceramic_claps, :ceramic_clap_tradition
    add_reference :ceramic_claps, :ceramic_clap_vessel_form
    add_reference :ceramic_claps, :ceramic_clap_temper

  end
end

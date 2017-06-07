class CreateBurials < ActiveRecord::Migration[5.0]
  def change

    create_table :burial_sexes do |t|
      t.string :name
      t.timestamps
    end

    create_table :burials do |t|
      t.string :unit
      t.string :strat
      t.string :feature_no
      t.string :new_burial_no
      t.string :age
      t.string :grid_ns
      t.string :grid_ew
      t.string :quad
      t.string :depth_begin
      t.string :depth_end
      t.string :date
      t.string :excavator
      t.string :record_field_key_no
      t.string :associated_artifacts
      t.string :description
      t.timestamps
    end

    add_reference :burials, :feature
    add_reference :burials, :burial_sex
    add_reference :burials, :occupation

  end
end

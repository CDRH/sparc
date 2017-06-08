class CreateCeramicVessels < ActiveRecord::Migration[5.0]
  def change
    create_table :ceramic_vessels do |t|
      t.string :unit
      t.string :strat
      t.string :strat_other
      t.string :feature_no
      t.string :sa_no
      t.string :fs_no
      t.string :salmon_vessel_no
      t.string :pottery_order_no
      t.string :record_field_key_no
      t.string :vessel_percentage
      t.string :lori_reed_analysis
      t.string :comments_lori_reed
      t.string :comments_other
    end

    # creating this migration while working from a partial table, so
    # there may be other controlled vocab tables to create later
    # and I am also making the assumption that vessels may have multiple
    # features because of the presence of the "other strata" column

    create_join_table :ceramic_vessels, :features do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :ceramic_vessel, index: true, foreign_key: true
    end

    # using "whole" in the title to distinguish between ceramic_vessel_forms table
    create_table :ceramic_whole_vessel_forms do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_vessel_lori_reed_forms do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_vessel_types do |t|
      t.string :name
      t.timestamps
    end

    create_table :ceramic_vessel_lori_reed_types do |t|
      t.string :name
      t.timestamps
    end


    add_reference :ceramic_vessels, :ceramic_whole_vessel_form
    add_reference :ceramic_vessels, :ceramic_vessel_lori_reed_form
    add_reference :ceramic_vessels, :ceramic_vessel_type
    add_reference :ceramic_vessels, :ceramic_vessel_lori_reed_type

  end
end

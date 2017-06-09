class CreateLithicTools < ActiveRecord::Migration[5.0]
  def change

    create_table :lithic_tools do |t|
      t.string :unit
      t.string :fs_no
      t.string :artifact_no
      t.string :fire_altered
      t.string :utilized
      t.integer :cortex_percentage
      t.integer :cortical_flakes
      t.integer :non_cortical_flakes
      t.integer :length
      t.integer :width
      t.integer :thickness
      t.integer :weight
      t.string :comments
      t.string :pii
    end

    # will be joining lithic tools to features via matching lithic_inventory records
    # adding features directly to lithic_tools because if any do NOT have a matching
    # inventory record (which should not happen but this is not an ideal world),
    # then it would be very difficult to link them to a unit, so I am sticking with
    # how we have previously linked up analysis tables
    create_join_table :lithic_tools, :features do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :lithic_tool, index: true, foreign_key: true
    end

    create_table :lithic_artifact_types do |t|
      t.string :code
      t.string :name
      t.timestamps
    end

    create_table :lithic_material_types do |t|
      t.integer :code
      t.string :name
      t.timestamps
    end

    create_table :lithic_conditions do |t|
      t.integer :code
      t.string :name
      t.timestamps
    end

    create_table :lithic_platform_types do |t|
      t.integer :code
      t.string :name
      t.timestamps
    end

    create_table :lithic_terminations do |t|
      t.integer :code
      t.string :name
      t.timestamps
    end

    add_reference :lithic_tools, :lithic_inventory
    add_reference :lithic_tools, :lithic_artifact_type
    add_reference :lithic_tools, :lithic_material_type
    add_reference :lithic_tools, :lithic_condition
    add_reference :lithic_tools, :lithic_platform_type
    add_reference :lithic_tools, :lithic_termination

  end
end

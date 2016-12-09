class CreateImageReferenceTables < ActiveRecord::Migration[5.0]
  def change
    # assocnoeg
    remove_column :images, :assocnoeg, :string
    create_table :image_assocnoegs do |t|
      t.string :name
      t.timestamps
    end
    add_reference :images, :image_assocnoeg, index: true, foreign_key: true

    # box
    remove_column :images, :box, :string
    create_table :image_boxes do |t|
      t.string :name
      t.timestamps
    end
    add_reference :images, :image_box, index: true, foreign_key: true

    # creator
    remove_column :images, :creator, :string
    create_table :image_creators do |t|
      t.string :name
      t.timestamps
    end
    add_reference :images, :image_creator, index: true, foreign_key: true

    # format
    remove_column :images, :format, :string
    create_table :image_formats do |t|
      t.string :name
      t.timestamps
    end
    add_reference :images, :image_format, index: true, foreign_key: true

    # human_remains
    remove_column :images, :human_remains, :string
    create_table :image_human_remains do |t|
      t.string :name
      t.boolean :displayable
      t.timestamps
    end
    add_reference :images, :image_human_remain, index: true, foreign_key: true

    # orientation
    remove_column :images, :orientation, :string
    create_table :image_orientations do |t|
      t.string :name
      t.timestamps
    end
    add_reference :images, :image_orientation, index: true, foreign_key: true

    # quality
    # NOTE: This could be separated into a many:many relationship
    # but due to small amount of rows leaving it for now
    remove_column :images, :image_quality, :string
    create_table :image_qualities do |t|
      t.string :name
      t.timestamps
    end
    add_reference :images, :image_quality, index: true, foreign_key: true
  end

end

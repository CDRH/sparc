class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string :site
      # Note: room and strat merely strings
      t.string :room
      t.string :strat
      # Note: using image_no instead of id
      # to fit the pattern of the other tables
      t.string :image_no
      t.string :format
      t.string :image_type
      t.string :assocnoeg
      t.string :box
      t.string :gride
      t.string :gridn
      t.string :orientation
      t.string :dep_beg
      t.string :dep_end
      # Note: string instead of date format to fit pattern of other tables
      t.string :date
      t.string :creator
      t.string :signi_art_no
      t.string :other_no
      t.string :human_remains
      t.string :comments
      t.string :storage_location
      t.string :data_entry
      t.string :image_quality
      t.string :notes
      t.timestamps
    end

    create_table :image_subjects do |t|
      t.string :subject
      t.timestamps
    end

    create_join_table :images, :image_subjects do |t|
      t.references :images, index: true, foreign_key: true
      t.references :image_subjects, index: true, foreign_key: true
      t.timestamps
    end

    create_join_table :images, :features do |t|
      t.references :feature, index: true, foreign_key: true
      t.references :image, index: true, foreign_key: true
    end
  end
end

class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :room_no
      t.string :feature_no
      t.string :strat
      t.string :floor_association
      t.string :feature_form
      t.string :other_associated_features
      t.string :grid
      t.string :depth_m_b_d
      t.string :occupation
      t.string :feature_type
      t.integer :feature_count
      t.string :feature_group
      t.string :residentual_feature
      t.string :real_feature
      t.string :location_in_room
      t.text :comments
      t.string :room_no

      t.timestamps null: false
    end
  end
end

class CreateResidentualFeatures < ActiveRecord::Migration
  def change
    create_table :residentual_features do |t|
      t.string :residentual_feature

      t.timestamps null: false
    end
  end
end

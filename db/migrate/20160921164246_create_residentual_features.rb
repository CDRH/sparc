class CreateResidentualFeatures < ActiveRecord::Migration[5.0]
  def change
    create_table :residentual_features do |t|
      t.string :residentual_feature

      t.timestamps null: false
    end
  end
end

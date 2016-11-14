class RenameResidentualTableAndColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :features, :residentual_feature_id, :residential_feature_id

    rename_table :residentual_features, :residential_features
    rename_column :residential_features, :residentual_feature, :residential_feature

    # add_index :residential_features, :residential_feature, :unique => true
    change_column :residential_features, :residential_feature, :string, :null => false
  end
end

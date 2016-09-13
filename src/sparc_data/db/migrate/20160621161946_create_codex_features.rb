class CreateCodexFeatures < ActiveRecord::Migration
  def change
    create_table :codex_features do |t|
      t.integer :codex_id
      t.integer :feature_id

      t.timestamps null: false
    end
  end
end

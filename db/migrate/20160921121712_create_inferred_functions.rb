class CreateInferredFunctions < ActiveRecord::Migration
  def change
    create_table :inferred_functions do |t|
      t.string :inferred_function

      t.timestamps null: false
    end
  end
end

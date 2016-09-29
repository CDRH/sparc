class CreateEggshellAffiliations < ActiveRecord::Migration[5.0]
  def change
    create_table :eggshell_affiliations do |t|
      t.string :affiliation

      t.timestamps
    end
  end
end

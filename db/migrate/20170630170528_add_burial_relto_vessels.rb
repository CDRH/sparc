class AddBurialReltoVessels < ActiveRecord::Migration[5.0]
  def change
    add_column :ceramic_vessels, :burial_related, :boolean
  end
end

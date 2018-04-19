class AddOrigSubjectToImage < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :orig_subjects, :string
  end
end

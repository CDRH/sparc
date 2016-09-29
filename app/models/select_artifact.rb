class SelectArtifact < ApplicationRecord
  belongs_to :select_artifact_occupation
  has_and_belongs_to_many :strata
  
  def to_label
    "#{artifact_no}"
  end
  def authorized_for_update?
    puts "---------#{current_user}"
    current_user != nil ? true : false
  end
  def authorized_for_delete?
    current_user != nil ? true : false
  end
  def authorized_for_create?
    puts "---------#{current_user}"
    current_user != nil ? true : false
  end
end

class SelectArtifact < ApplicationRecord
  belongs_to :occupation
  has_and_belongs_to_many :strata
  has_many :units, :through => :strata

  def self.sorted
    order("artifact_no")
  end

  def to_label
    artifact_no
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

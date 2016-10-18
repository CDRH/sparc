class SelectArtifactOccupation < ApplicationRecord
  has_many :select_artifacts

  validates_uniqueness_of :occupation

  def to_label
    occupation
  end

end

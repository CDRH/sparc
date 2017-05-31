class SelectArtifactOccupation < ApplicationRecord
  has_many :select_artifacts

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
  end

end

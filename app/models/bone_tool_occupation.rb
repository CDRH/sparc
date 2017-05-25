class BoneToolOccupation < ActiveRecord::Base
  has_many :bone_tools

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
  end
end

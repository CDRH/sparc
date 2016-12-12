class BoneToolOccupation < ActiveRecord::Base
  has_many :bone_tools

  validates_uniqueness_of :occupation

  def self.sorted
    order("occupation")
  end

  def to_label
    occupation
  end
end

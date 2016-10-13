class BoneToolOccupation < ActiveRecord::Base
  has_many :bone_tools

  validates_uniqueness_of :occupation

  def to_label
    "#{occupation}"
  end
end

class TShapedDoor < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :t_shaped_door

  def self.sorted
    order("t_shaped_door")
  end

  def to_label
    t_shaped_door
  end
end

class TShapedDoor < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :name

  def self.sorted
    order("t_shaped_doors.name")
  end

  def to_label
    name
  end
end

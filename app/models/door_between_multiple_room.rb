class DoorBetweenMultipleRoom < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :name

  def self.sorted
    order("door_between_multiple_rooms.name")
  end

  def to_label
    name
  end
end

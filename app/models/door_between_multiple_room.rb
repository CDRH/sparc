class DoorBetweenMultipleRoom < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :door_between_multiple_rooms

  def self.sorted
    order("door_between_multiple_rooms")
  end

  def to_label
    door_between_multiple_rooms
  end
end

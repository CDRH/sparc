class DoorwaySealed < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :doorway_sealed

  def self.sorted
    order("doorway_sealed")
  end

  def to_label
    doorway_sealed
  end
end

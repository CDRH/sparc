class DoorwaySealed < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :name

  def self.sorted
    order("doorway_sealeds.name")
  end

  def to_label
    name
  end
end

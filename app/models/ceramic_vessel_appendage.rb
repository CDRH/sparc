class CeramicVesselAppendage < ActiveRecord::Base
  has_many :ceramics

  validates_uniqueness_of :name

  def self.sorted
    order("ceramic_vessel_appendages.name")
  end

  def to_label
    name
  end
end

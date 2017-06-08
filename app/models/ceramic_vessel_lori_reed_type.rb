class CeramicVesselLoriReedType < ActiveRecord::Base
  has_many :ceramic_vessels

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
  end
end

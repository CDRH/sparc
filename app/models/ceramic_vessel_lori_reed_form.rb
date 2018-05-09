class CeramicVesselLoriReedForm < ActiveRecord::Base
  has_many :ceramic_vessels

  validates_uniqueness_of :name

  def self.sorted
    order("ceramic_vessel_lori_reed_forms.name")
  end

  def to_label
    name
  end
end

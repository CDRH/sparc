class CeramicWholeVesselForm < ActiveRecord::Base
  has_many :ceramic_vessels

  validates_uniqueness_of :name

  def self.sorted
    order("ceramic_whole_vessel_forms.name")
  end

  def to_label
    name
  end
end

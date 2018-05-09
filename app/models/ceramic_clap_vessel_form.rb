class CeramicClapVesselForm < ActiveRecord::Base
  has_many :ceramic_claps

  validates_uniqueness_of :name

  def self.sorted
    order("ceramic_clap_vessel_forms.name")
  end

  def to_label
    name
  end
end

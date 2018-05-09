class CeramicExteriorPigment < ActiveRecord::Base
  has_many :ceramics

  validates_uniqueness_of :name

  def self.sorted
    order("ceramic_exterior_pigments.name")
  end

  def to_label
    name
  end
end

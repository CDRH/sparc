class CeramicInteriorSurface < ActiveRecord::Base
  has_many :ceramics

  validates_uniqueness_of :name

  def self.sorted
    order("ceramic_interior_surfaces.name")
  end

  def to_label
    name
  end
end

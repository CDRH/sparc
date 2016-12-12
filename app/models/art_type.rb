class ArtType < ApplicationRecord
  has_many :soils

  validates_uniqueness_of :art_type

  def self.sorted
    order("art_type")
  end

  def to_label
    art_type
  end
end

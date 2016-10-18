class ArtType < ApplicationRecord
  has_many :soils

  validates_uniqueness_of :art_type

  def to_label
    art_type
  end
end

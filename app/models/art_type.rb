class ArtType < ApplicationRecord
  has_many :soils

  def to_label
    art_type
  end
end

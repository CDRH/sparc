class ArtType < ApplicationRecord
  has_many :soils

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
  end
end

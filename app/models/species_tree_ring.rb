class SpeciesTreeRing < ApplicationRecord
  has_many :tree_rings

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
  end
end

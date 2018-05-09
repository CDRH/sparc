class SpeciesTreeRing < ApplicationRecord
  has_many :tree_rings

  validates_uniqueness_of :name

  def self.sorted
    order("species_tree_rings.name")
  end

  def to_label
    name
  end
end

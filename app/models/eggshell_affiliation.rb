class EggshellAffiliation < ApplicationRecord
  has_many :eggshells

  validates_uniqueness_of :affiliation

  def self.sorted
    order("affiliation")
  end

  def to_label
    affiliation
  end
end

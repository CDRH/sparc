class EggshellItem < ApplicationRecord
  has_many :eggshells

  validates_uniqueness_of :name

  def self.sorted
    order("eggshell_items.name")
  end

  def to_label
    name
  end
end

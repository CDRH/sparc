class EggshellItem < ApplicationRecord
  has_many :eggshells

  validates_uniqueness_of :item

  def self.sorted
    order("item")
  end

  def to_label
    item
  end
end

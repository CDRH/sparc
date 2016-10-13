class EggshellItem < ApplicationRecord
  has_many :eggshells

  validates_uniqueness_of :item

  def to_label
    "#{item}"
  end
end

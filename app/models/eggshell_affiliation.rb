class EggshellAffiliation < ApplicationRecord
  has_many :eggshells

  validates_uniqueness_of :affiliation

  def to_label
    "#{affiliation}"
  end
end

class BurialSex < ApplicationRecord
  has_many :burials

  validates_uniqueness_of :name

  def self.sorted
    order("burial_sexes.name")
  end

  def to_label
    name
  end
end

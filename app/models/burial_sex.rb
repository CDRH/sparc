class BurialSex < ApplicationRecord
  has_many :burials

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
  end
end

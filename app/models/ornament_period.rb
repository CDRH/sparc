class OrnamentPeriod < ApplicationRecord
  has_many :ornaments

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
  end
end

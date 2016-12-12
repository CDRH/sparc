class OrnamentPeriod < ApplicationRecord
  has_many :ornaments

  validates_uniqueness_of :period

  def self.sorted
    order("period")
  end

  def to_label
    period
  end
end

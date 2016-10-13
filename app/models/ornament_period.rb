class OrnamentPeriod < ApplicationRecord
  has_many :ornaments

  validates_uniqueness_of :period

  def to_label
    period
  end
end

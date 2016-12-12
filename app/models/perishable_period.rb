class PerishablePeriod < ApplicationRecord
  has_many :perishables

  validates_uniqueness_of :period

  def self.sorted
    order("period")
  end

  def to_label
    period
  end
end

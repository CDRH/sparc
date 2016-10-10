class OrnamentPeriod < ApplicationRecord
  has_many :ornaments

  def to_label
    period
  end
end

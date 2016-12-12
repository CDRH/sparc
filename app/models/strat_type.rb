class StratType < ActiveRecord::Base
  has_many :strata

  validates_uniqueness_of :strat_type

  def self.sorted
    order("strat_type")
  end

  def to_label
    strat_type
  end
end

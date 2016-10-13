class StratType < ActiveRecord::Base
  has_many :strata

  validates_uniqueness_of :strat_type

  def to_label
    "#{strat_type}"
  end
end

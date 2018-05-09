class StratGrouping < ActiveRecord::Base
  has_many :strat_types
  has_many :strata, -> {distinct}, :through => :strat_types
  has_many :units, -> {distinct}, :through => :strata

  validates_uniqueness_of :name

  def self.sorted
    order("strat_groupings.name")
  end

  def to_label
    name
  end
end

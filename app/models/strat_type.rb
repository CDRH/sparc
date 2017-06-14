class StratType < ActiveRecord::Base
  belongs_to :strat_grouping
  has_many :strata

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
  end
end

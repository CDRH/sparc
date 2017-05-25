class StratType < ActiveRecord::Base
  has_many :strata

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
  end
end

class FeatureOccupation < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :occupation

  def self.sorted
    order("occupation")
  end

  def to_label
    occupation
  end
end

class ResidentialFeature < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :residential_feature

  def self.sorted
    order("residential_feature")
  end

  def to_label
    residential_feature
  end
end

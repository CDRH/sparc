class FeatureType < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :feature_type

  def self.sorted
    order("feature_type")
  end

  def to_label
    feature_type
  end
end

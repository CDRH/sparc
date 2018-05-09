class FeatureType < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :name

  def self.sorted
    order("feature_types.name")
  end

  def to_label
    name
  end
end

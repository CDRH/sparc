class FeatureType < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :feature_type

  def to_label
    "#{feature_type}"
  end
end

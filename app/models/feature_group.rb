class FeatureGroup < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :feature_group

  def to_label
    "#{feature_group}"
  end
end

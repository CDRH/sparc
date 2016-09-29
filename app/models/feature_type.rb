class FeatureType < ActiveRecord::Base
  def to_label
    "#{feature_type}"
  end
end

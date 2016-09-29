class FeatureGroup < ActiveRecord::Base
  def to_label
    "#{feature_group}"
  end
end

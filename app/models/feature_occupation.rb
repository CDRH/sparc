class FeatureOccupation < ActiveRecord::Base
  def to_label
    "#{occupation}"
  end
end

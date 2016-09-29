class ResidentualFeature < ActiveRecord::Base
  def to_label
    "#{residentual_feature}"
  end
end

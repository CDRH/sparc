class ResidentualFeature < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :residentual_feature

  def to_label
    "#{residentual_feature}"
  end
end

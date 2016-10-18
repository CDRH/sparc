class ResidentialFeature < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :residential_feature

  def to_label
    "#{residential_feature}"
  end
end

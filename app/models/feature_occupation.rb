class FeatureOccupation < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :occupation

  def to_label
    "#{occupation}"
  end
end

class ResidentialFeature < ActiveRecord::Base
  has_many :features

  validates_uniqueness_of :name

  def self.sorted
    order("residential_features.name")
  end

  def to_label
    name
  end
end

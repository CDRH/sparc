class CeramicVariety < ActiveRecord::Base
  has_many :ceramics

  validates_uniqueness_of :name

  def self.sorted
    order("ceramic_varieties.name")
  end

  def to_label
    name
  end
end

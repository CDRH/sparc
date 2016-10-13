class StratOccupation < ActiveRecord::Base
  has_many :strata

  validates_uniqueness_of :occupation

  def to_label
    "#{occupation}"
  end
end

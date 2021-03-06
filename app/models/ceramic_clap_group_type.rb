class CeramicClapGroupType < ActiveRecord::Base
  has_many :ceramic_claps

  validates_uniqueness_of :name

  def self.sorted
    order("ceramic_clap_group_types.name")
  end

  def to_label
    name
  end
end

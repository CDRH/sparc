class CeramicClapTemper < ActiveRecord::Base
  has_many :ceramic_claps

  validates_uniqueness_of :name

  def self.sorted
    order("ceramic_clap_tempers.name")
  end

  def to_label
    name
  end
end

class CeramicClapTradition < ActiveRecord::Base
  has_many :ceramic_claps

  validates_uniqueness_of :name

  def self.sorted
    order("ceramic_clap_traditions.name")
  end

  def to_label
    name
  end
end

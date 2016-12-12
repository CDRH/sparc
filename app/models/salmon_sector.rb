class SalmonSector < ActiveRecord::Base
  has_many :units

  validates_uniqueness_of :salmon_sector

  def self.sorted
    order("salmon_sector")
  end

  def to_label
    salmon_sector
  end

  def authorized_for_update?
    puts "---------#{current_user}"
    current_user != nil ? true : false
  end
  def authorized_for_delete?
    current_user != nil ? true : false
  end
  def authorized_for_create?
    puts "---------#{current_user}"
    current_user != nil ? true : false
  end
end

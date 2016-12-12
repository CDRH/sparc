class UnitClass < ActiveRecord::Base
  has_many :units

  validates_uniqueness_of :unit_class

  def self.sorted
    order("unit_class")
  end

  def to_label
    unit_class
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

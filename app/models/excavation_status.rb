class ExcavationStatus < ActiveRecord::Base
  has_many :units

  validates_uniqueness_of :excavation_status

  def self.sorted
    order("excavation_status")
  end

  def to_label
    excavation_status
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

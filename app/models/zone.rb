class Zone < ActiveRecord::Base
  has_many :units
  has_many :images, :through => :units
  
  validates_uniqueness_of :number

  def self.sorted
    order("number")
  end

  def to_label
    number
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

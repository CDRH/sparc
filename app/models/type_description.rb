class TypeDescription < ActiveRecord::Base
  has_many :units

  validates_uniqueness_of :type_description

  def self.sorted
    order("type_description")
  end

  def to_label
    type_description
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

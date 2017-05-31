class IntactRoof < ActiveRecord::Base
  has_many :units

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
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

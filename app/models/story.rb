class Story < ActiveRecord::Base
  has_many :units

  validates_uniqueness_of :story

  def self.sorted
    order("story")
  end

  def to_label
    story
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

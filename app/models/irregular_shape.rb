class IrregularShape < ActiveRecord::Base
  has_many :units

  validates_uniqueness_of :irregular_shape

  def self.sorted
    order("irregular_shape")
  end

  def to_label
    irregular_shape
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

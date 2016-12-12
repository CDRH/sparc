class InferredFunction < ActiveRecord::Base
  has_many :units

  validates_uniqueness_of :inferred_function

  def self.sorted
    order("inferred_function")
  end

  def to_label
    inferred_function
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

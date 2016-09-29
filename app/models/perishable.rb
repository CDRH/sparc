class Perishable < ApplicationRecord
  belongs_to :perishable_period
  has_and_belongs_to_many :features
  
  def to_label
    "#{fs_number}"
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

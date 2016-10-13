class Ornament < ApplicationRecord
  belongs_to :ornament_period
  belongs_to :eggshell_affiliation
  belongs_to :feature
  
  def to_label
    "#{museum_specimen_no}"
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

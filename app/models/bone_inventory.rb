class BoneInventory < ApplicationRecord
  has_and_belongs_to_many :features
  has_many :strata, :through => :features
  has_many :units, :through => :strata
  
  def to_label
    "#{comments}"
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

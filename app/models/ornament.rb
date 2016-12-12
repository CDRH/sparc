class Ornament < ApplicationRecord
  belongs_to :ornament_period
  belongs_to :feature
  has_many :strata, :through => :feature
  has_many :units, :through => :strata

  def self.sorted
    order("museum_specimen_no")
  end

  def to_label
    museum_specimen_no
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

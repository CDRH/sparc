class Burial < ActiveRecord::Base
  belongs_to :burial_sex
  belongs_to :occupation
  belongs_to :feature
  has_many :strata, -> {distinct}, :through => :feature
  has_many :units, -> {distinct}, :through => :strata

  def self.sorted
    order("new_burial_no")
  end

  def to_label
    new_burial_no
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

class CeramicVessel < ActiveRecord::Base
  belongs_to :feature
  has_many :strata, -> {distinct}, :through => :feature
  has_many :units, -> {distinct}, :through => :strata

  belongs_to :ceramic_inventory

  belongs_to :ceramic_whole_vessel_form
  belongs_to :ceramic_vessel_lori_reed_form
  belongs_to :ceramic_vessel_type
  belongs_to :ceramic_vessel_lori_reed_type

  def self.sorted
    order("fs_no")
  end

  def to_label
    fs_no
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

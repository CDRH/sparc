class CeramicClap < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

  belongs_to :ceramic_clap_type
  belongs_to :ceramic_clap_group_type
  belongs_to :ceramic_clap_tradition
  belongs_to :ceramic_clap_vessel_form
  belongs_to :ceramic_clap_temper

  def self.sorted
    order("record_field_key_no")
  end

  def to_label
    record_field_key_no
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

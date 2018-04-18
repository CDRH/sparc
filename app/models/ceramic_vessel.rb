class CeramicVessel < ActiveRecord::Base
  belongs_to :feature
  has_many :strata, -> {distinct}, :through => :feature
  has_many :units, -> {distinct}, :through => :strata

  belongs_to :ceramic_inventory

  belongs_to :ceramic_whole_vessel_form
  belongs_to :ceramic_vessel_lori_reed_form
  belongs_to :ceramic_vessel_type
  belongs_to :ceramic_vessel_lori_reed_type

  def self.abstraction
    {
      assoc_input_type: "input",
      assoc_input_column: "fs_no",
      description: <<-DESC
The Ceramic Vessels table derived from the original San Juan Valley
Archaeological Program with a whole vessel inventory (roughly 330 vessels)
created by Hayward Franklin. Lori Reed subsequenty modified this file as she
undertaken some analysis in the early 2000s. It contains data on a sample of the
whole ceramic vessels from Salmon Pueblo conducted by L. Reed thus far. During
the SPARC project (2015-2018), data within this table were edited and
cross-checked against other sources.
      DESC
    }
  end

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

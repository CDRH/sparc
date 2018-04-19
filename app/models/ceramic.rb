class Ceramic < ActiveRecord::Base
  belongs_to :feature
  has_many :strata, -> {distinct}, :through => :feature
  has_many :units, -> {distinct}, :through => :strata

  belongs_to :ceramic_inventory

  belongs_to :ceramic_vessel_appendage
  belongs_to :ceramic_vessel_form
  belongs_to :ceramic_vessel_part
  belongs_to :ceramic_exterior_pigment
  belongs_to :ceramic_interior_pigment
  belongs_to :ceramic_exterior_surface
  belongs_to :ceramic_interior_surface
  belongs_to :ceramic_temper
  belongs_to :ceramic_paste
  belongs_to :ceramic_slip
  belongs_to :ceramic_tradition
  belongs_to :ceramic_variety
  belongs_to :ceramic_ware
  belongs_to :ceramic_specific_type
  belongs_to :ceramic_style

  def self.abstraction
    {
      assoc_input_type: "input",
      assoc_input_column: "fs_no",
      description: <<-DESC
This table, completed in 2005, represents the latest ceramic analysis of a
sample from Salmon Pueblo's ceramic assemblage. Lori Reed and her Animas Ceramic
Consulting staff completed this analysis as part of Archaeology Southwest's
Salmon Project (2001-2018). The Chacoan occupation was targeted with the sample
of about 40,000 sherds. During the SPARC project (2015-2018), data within this
table were edited and cross-checked against other sources.
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

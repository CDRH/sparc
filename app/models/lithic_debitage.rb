class LithicDebitage < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

  belongs_to :lithic_inventory

  belongs_to :lithic_material_type
  belongs_to :lithic_condition
  belongs_to :lithic_platform_type
  belongs_to :lithic_termination

  def self.abstraction
    {
      assoc_input_type: "input",
      assoc_input_column: "fs_no",
      description: <<-DESC
The Lithic Debitage analysis table was created by David Witt in 2013 as part of
his dissertation work focused on the Middle San Juan region. During the SPARC
project (2015-2018), data within this table were edited and cross-checked
against other sources.
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

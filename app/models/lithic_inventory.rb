class LithicInventory < ApplicationRecord
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

  has_many :lithic_debitages
  has_many :lithic_tools

  def self.abstraction
    {
      assoc_input_type: "input",
      assoc_input_column: "fs_no",
      description: <<-DESC
The Lithic Inventory table was created during Archaeology Southwest's Salmon
Project (2001-2018) as lithic and ground stone artifacts were repackaged into
archival quality materials. During the SPARC project (2015-2018), data within
this table were edited and cross-checked against other sources.
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

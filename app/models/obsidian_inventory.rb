class ObsidianInventory < ApplicationRecord
  belongs_to :feature
  has_many :strata, -> {distinct}, :through => :feature
  has_many :units, -> {distinct}, :through => :strata

  belongs_to :occupation
  belongs_to :obsidian_identified_source

  def self.abstraction
    {
      assoc_input_type: "input",
      assoc_input_column: "fs_no"
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

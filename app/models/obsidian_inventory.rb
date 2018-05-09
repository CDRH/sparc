class ObsidianInventory < ApplicationRecord
  belongs_to :feature
  has_many :strata, -> {distinct}, :through => :feature
  has_many :units, -> {distinct}, :through => :strata

  belongs_to :occupation
  belongs_to :obsidian_identified_source

  def self.abstraction
    {
      assoc_column: "fs_no",
      description: <<-DESC,
The Obsidian Table is an analysis file that combines all Salmon obsidian data
from both the original project and more recent sampling and restudy of the
obsidian data (part of Archaeology Southwest's Salmon Project (2001-2018).
During the SPARC project (2015-2018), data within this table were edited and
cross-checked against other sources.
      DESC
      disabled: %w[],
      labels: {
        fs_no: "FS Number"
      },
      primary: %w[fs_no obsidian_identified_source],
      selects: %w[]
    }
  end

  def self.sorted
    order("obsidian_inventories.fs_no")
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

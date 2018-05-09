class FaunalInventory < ApplicationRecord
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

  has_many :bone_tools
  has_many :faunal_artifacts

  def self.abstraction
    {
      assoc_col: "record_field_key_no",
      description: <<-DESC,
The Faunal Inventory table was created during Archaeology Southwest's Salmon
Project (2001-2018) as bone items were repackaged into archival quality
materials. During the SPARC project (2015-2018), data within this table were
edited and cross-checked against other sources.
      DESC
      disabled: %w[],
      labels: {
        fs_no: "FS Number",
        sa_no: "SA Number"
      },
      primary: %w[fs_no sa_no comments],
      selects: %w[]
    }
  end

  def self.sorted
    order("faunal_inventories.comments")
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

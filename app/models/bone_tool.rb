class BoneTool < ActiveRecord::Base
  belongs_to :occupation
  belongs_to :faunal_inventory
  belongs_to :feature

  has_many :strata, -> { distinct }, :through => :feature
  has_many :units, -> { distinct }, :through => :strata

  def self.abstraction
    {
      assoc_input_type: "input",
      assoc_input_column: "fs_no",
      description: <<-DESC
This Bone Tool analysis table derives from a recent Eastern New Mexico
University masters thesis (Lloyd 2007) on bone tools. During the SPARC project
(2015-2018), data within this table were edited and cross-checked against other
sources.
      DESC
    }
  end

  def self.sorted
    order("bone_tools.fs_no")
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

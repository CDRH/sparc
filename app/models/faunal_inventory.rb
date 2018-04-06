class FaunalInventory < ApplicationRecord
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

  has_many :bone_tools
  has_many :faunal_artifacts

  def self.abstraction
    {
      assoc_input_type: "input",
      assoc_input_column: "record_field_key_no"
    }
  end

  def self.sorted
    order("comments")
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

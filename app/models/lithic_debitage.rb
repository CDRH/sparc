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
      assoc_col: "fs_no",
      description: <<-DESC,
The Lithic Debitage analysis table was created by David Witt in 2013 as part of
his dissertation work focused on the Middle San Juan region. During the SPARC
project (2015-2018), data within this table were edited and cross-checked
against other sources.
      DESC
      disabled: %w[],
      labels: {
        fs_no: "FS Number",
        artifact_no: "Artifact Number"
      },
      primary: %w[
        fs_no artifact_no lithic_material_type lithic_condition fire_altered
        utilized lithic_platform_type lithic_termination notes
      ],
      selects: %w[fire_altered utilized]
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

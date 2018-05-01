class FaunalArtifact < ActiveRecord::Base
  belongs_to :faunal_inventory
  belongs_to :feature

  has_many :strata, -> { distinct }, :through => :feature
  has_many :units, -> { distinct }, :through => :strata

  def self.abstraction
    {
      assoc_col: "fs_no",
      description: <<-DESC,
This file derives from Archaeology Southwest's Salmon Project (2001-2018). Kathy
Roler Durand (Eastern New Mexico University) and her students did the analysis.
It provides analytical data on a sample of the fauna from Salmon. During the
SPARC project (2015-2018), data within this table were edited and cross-checked
against other sources.
      DESC
      disabled: %w[],
      labels: {
        fs_no: "FS No."
      },
      primary: %w[fs_no],
      selects: %w[]
    }
  end

  def self.sorted
    order("faunal_artifacts.fs_no")
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

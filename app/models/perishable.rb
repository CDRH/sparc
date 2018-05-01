class Perishable < ApplicationRecord
  belongs_to :occupation
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

  def self.abstraction
    {
      assoc_col: "salmon_museum_number",
      description: <<-DESC,
The Perishables analysis table combines the 1980s Salmon Ruins Museum inventory
file with Laurie Webster's analysis (part of Archaeology Southwest's Salmon
Project (2001-2018) of Salmon fiber artifacts into a single table. During the
SPARC project (2015-2018), data within this table were edited and cross-checked
against other sources.
      DESC
      disabled: %w[],
      labels: {
        fs_no: "FS Number",
        sa_no: "SA Number"
      },
      primary: %w[
        salmon_museum_number fs_no sa_no artifact_type comments comments_other
      ],
      selects: %w[]
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

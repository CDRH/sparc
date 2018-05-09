class Soil < ApplicationRecord
  belongs_to :art_type
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

 def self.abstraction
    {
      assoc_col: "sample_no",
      description: <<-DESC,
The Soil Inventory table was created during Salmon Ruins Museum inventory work
in the 1980s and was updated during Archaeology Southwest's Salmon Project
(2001-2018). This table contains data on the remaining soil samples collected
(but not processed or analyzed) during the original Salmon work (1970s). During
the SPARC project (2015-2018), data within this table were edited and
cross-checked against other sources.
      DESC
      disabled: %w[],
      labels: {
        sample_no: "SA Number",
        fs_no: "FS Number",
        art_type: "Art Type"
      },
      primary: %w[sample_no fs_no art_type comments],
      selects: %w[art_type]
    }
  end

  def self.sorted
    order("soils.comments")
  end

  def to_label
    comments
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

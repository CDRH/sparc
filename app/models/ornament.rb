class Ornament < ApplicationRecord
  belongs_to :occupation
  belongs_to :feature
  has_many :strata, -> {distinct}, :through => :feature
  has_many :units, -> {distinct}, :through => :strata

  def self.abstraction
    {
      assoc_col: "salmon_museum_no",
      description: <<-DESC,
The Ornaments table is an analysis table that derives from the original Salmon
San Juan Valley Archaeological Program in the 1970s. It was subsequently updated
during the Salmon Ruins Museum inventory work in the 1980s. It includes data on
artifacts identified as ornaments. As part of the SPARC Project (2015-2018), the
table has been edited and data within has been cross-checked against other
sources.
      DESC
      disabled: %w[],
      labels: {
        salmon_museum_no: "Museum Specimen Number",
        sa_no: "SA Number"
      },
      primary: %w[salmon_museum_no sa_no item],
      selects: %w[item]
    }
  end

  def self.sorted
    order("ornaments.salmon_museum_no")
  end

  def to_label
    salmon_museum_no
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

class PollenInventory < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> { distinct }, :through => :strata

  def self.abstraction
    {
      assoc_col: "sa_no",
      description: <<-DESC,
The Pollen Inventory table derives from Salmon Ruins Museum inventory work in
the 1980s and was updated during Archaeology Southwest's Salmon Project
(2001-2018). This table contains data on the remaining pollen samples collected
(but not processed or analyzed) during the original Salmon work (1970s). During
the SPARC project (2015-2018), data within this table were edited and
cross-checked against other sources.
      DESC
      disabled: %w[],
      labels: {
        sa_no: "SA Number",
        salmon_museum_no: "Salmon Museum Number"
      },
      primary: %w[sa_no salmon_museum_no],
      selects: %w[]
    }
  end

  def self.sorted
    order("pollen_inventories.salmon_museum_no")
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

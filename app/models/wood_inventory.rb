class WoodInventory < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> { distinct }, :through => :strata

  def self.abstraction
    {
      assoc_col: "sa_no",
      description: <<-DESC,
The Wood Inventory table derives from the Salmon Ruins Museum inventory work in
the 1980s and was updated during Archaeology Southwest's Salmon Project
(2001-2018). The table contains data on most of the remaining wood artifacts and
samples collected during the 1970s Salmon excavations. During the SPARC project
(2015-2018), data within this table were edited and cross-checked against other
sources.
      DESC
      disabled: %w[feature_no],
      labels: {
        salmon_museum_no: "Salmon Museum Number",
        record_field_key_no: "Record Field Key Number"
      },
      primary: %w[salmon_museum_no record_field_key_no description],
      selects: %w[]
    }
  end

  def self.sorted
    order("salmon_museum_no")
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

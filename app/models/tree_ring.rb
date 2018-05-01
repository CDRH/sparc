class TreeRing < ApplicationRecord
  belongs_to :occupation
  belongs_to :species_tree_ring
  belongs_to :stratum
  has_one :unit, -> {distinct}, :through => :stratum

  def self.abstraction
    {
      assoc_col: "trl_no",
      description: <<-DESC,
The Tree-ring table combines all Salmon tree-ring data from both the original
project and Tom Windes’ work (part of Archaeology Southwest's Salmon Project -
2001-2018) to comprehensively sample Salmon Pueblo’s in situ wood assemblage.
During the SPARC project (2015-2018), data within this table were edited and
cross-checked against other sources.
      DESC
      disabled: %w[],
      labels: {
        trl_no: "TRL No."
      },
      primary: %w[trl_no species_tree_ring outer_date cutting_date comments],
      selects: %w[cutting_date]
    }
  end

  def self.sorted
    order("trl_no")
  end

  def to_label
    trl_no
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

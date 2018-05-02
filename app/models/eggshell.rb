class Eggshell < ActiveRecord::Base
  belongs_to :eggshell_item
  belongs_to :occupation
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

  def self.abstraction
    {
      assoc_col: "salmon_museum_no",
      description: <<-DESC,
The Eggshell inventory table derives from Salmon Ruins Museum inventory work in
the 1980s and was updated during Archaeology Southwest's Salmon Project
(2001-2018). It summarizes data on eggshell from Salmon Pueblo. During the SPARC
project (2015-2018), data within this table were edited and cross-checked
against other sources.
      DESC
      disabled: %w[],
      labels: {
        salmon_museum_no: "Salmon Museum Number"
      },
      primary: %w[salmon_museum_no eggshell_item],
      selects: %w[eggshell_item]
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

class Unit < ActiveRecord::Base
  belongs_to :excavation_status
  belongs_to :inferred_function
  belongs_to :intact_roof
  belongs_to :irregular_shape
  belongs_to :salmon_sector
  belongs_to :story
  belongs_to :type_description
  belongs_to :unit_class
  belongs_to :occupation
  belongs_to :zone

  has_and_belongs_to_many :documents
  has_many :document_binders, -> {distinct}, :through => :documents
  has_many :document_types, -> {distinct}, :through => :documents
  has_many :features, :through => :strata
  has_many :images, :through => :features
  has_many :strata
  has_many :tree_rings, :through => :strata

  # feature objects
  has_many :bone_tools, :through => :features
  has_many :ceramics, :through => :features
  has_many :ceramic_claps, :through => :features
  has_many :ceramic_inventories, :through => :features
  has_many :ceramic_vessels, :through => :features
  has_many :eggshells, :through => :features
  has_many :faunal_artifacts, :through => :features
  has_many :faunal_inventories, :through => :features
  has_many :images, :through => :features
  has_many :lithic_debitages, :through => :features
  has_many :lithic_inventories, :through => :features
  has_many :lithic_tools, :through => :features
  has_many :obsidian_inventories, :through => :features
  has_many :ornaments, :through => :features
  has_many :perishables, :through => :features
  has_many :pollen_inventories, :through => :features
  has_many :soils, :through => :features
  has_many :wood_inventories, :through => :features

  validates_uniqueness_of :unit_no

  def self.abstraction
    {
      assoc_col: "unit_no",
      description: <<-DESC,
During Archaeology Southwest's Salmon Project (2001-2018), Paul Reed created
this Unit analysis table to manage room and excavation unit data across the
site. This file summarizes the data on each room and excavation unit at Salmon.
It includes dimensions, inferred use or purpose, period of occupation, and other
data. During the SPARC project (2015-2018), data within this table were edited
and cross-checked against other sources.
      DESC
      disabled: %w[],
      labels: {
        unit_no: "Unit Number"
      },
      primary: %w[unit_no unit_class comments],
      selects: %w[]
    }
  end

  def self.sorted
    order("units.unit_no")
  end

  def media_maps
    documents.where(document_type: DocumentType.where(code: "MM"))
  end

  def to_label
    unit_no
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

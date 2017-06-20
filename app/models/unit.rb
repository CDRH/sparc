class Unit < ActiveRecord::Base
  belongs_to :excavation_status
  belongs_to :inferred_function
  belongs_to :intact_roof
  belongs_to :room_type
  belongs_to :irregular_shape
  belongs_to :salmon_sector
  belongs_to :story
  belongs_to :type_description
  belongs_to :unit_class
  belongs_to :occupation
  belongs_to :zone

  has_and_belongs_to_many :documents
  has_many :document_binders, -> {distinct}, :through => :documents
  has_many :features, :through => :strata
  has_many :images, :through => :features
  has_many :strata

  # strata objects
  has_many :bone_tools, :through => :strata
  has_many :select_artifacts, :through => :strata

  # feature objects
  has_many :bone_inventories, :through => :features
  has_many :ceramic_inventories, :through => :features
  has_many :eggshells, :through => :features
  has_many :images, :through => :features
  has_many :lithic_inventories, :through => :features
  has_many :ornaments, :through => :features
  has_many :perishables, :through => :features
  has_many :soils, :through => :features

  validates_uniqueness_of :unit_no

  def self.sorted
    order("units.unit_no")
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

class Feature < ActiveRecord::Base
  belongs_to :feature_group
  belongs_to :occupation
  belongs_to :feature_type
  belongs_to :doorway_sealed
  belongs_to :door_between_multiple_room
  belongs_to :residential_feature
  belongs_to :t_shaped_door

  has_and_belongs_to_many :strata
  has_many :units, :through => :strata

  has_many :bone_tools
  has_many :burials
  has_many :ceramic_vessels
  has_many :faunal_artifacts
  has_many :obsidian_inventories
  has_many :ornaments
  has_and_belongs_to_many :ceramic_claps
  has_and_belongs_to_many :ceramic_inventories
  has_and_belongs_to_many :eggshells
  has_and_belongs_to_many :faunal_inventories
  has_and_belongs_to_many :images
  has_and_belongs_to_many :lithic_inventories
  has_and_belongs_to_many :perishables
  has_and_belongs_to_many :pollen_inventories
  has_and_belongs_to_many :select_artifacts
  has_and_belongs_to_many :soils
  has_and_belongs_to_many :wood_inventories

  def self.abstraction
    {
      assoc_col: "feature_no",
      description: <<-DESC,
This analysis table contains data on features from Salmon Pueblo (including
rooms and extramural areas). It was built by Paul Reed and staff (beginning in
2004) by extracting and summarizing feature information from the field forms
and, in some cases, creating new feature numbers and descriptions during
Archaeology Southwest's Salmon Project (2001-2018). During the SPARC project
(2015-2018), data within this table were edited and cross-checked against other
sources.
      DESC
      disabled: %w[],
      labels: {
        feature_no: "Feature Number"
      },
      primary: %w[
        feature_no occupation feature_group feature_type residential_feature
        t_shaped_door door_between_multiple_room doorway_sealed comments
      ],
      selects: %w[]
    }
  end

  def self.sorted
    order("feature_no")
  end

  def to_label
    "#{strata.map{|s| s.to_label}.join(', ')} : #{feature_no}"
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

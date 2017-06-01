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

  has_many :burials
  has_many :ornaments
  has_and_belongs_to_many :bone_inventories
  has_and_belongs_to_many :ceramic_inventories
  has_and_belongs_to_many :eggshells
  has_and_belongs_to_many :images
  has_and_belongs_to_many :lithic_inventories
  has_and_belongs_to_many :perishables
  has_and_belongs_to_many :pollen_inventories
  has_and_belongs_to_many :soils
  has_and_belongs_to_many :wood_inventories

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

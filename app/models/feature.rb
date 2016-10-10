class Feature < ActiveRecord::Base
  belongs_to :excavtion_status
  belongs_to :feature_group
  belongs_to :feature_occupation
  belongs_to :feature_type
  belongs_to :doorway_sealed
  belongs_to :door_between_multiple_room
  belongs_to :residentual_feature
  belongs_to :t_shaped_door

  has_and_belongs_to_many :strata
  has_many :units, :through => :strata

  has_and_belongs_to_many :soils

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

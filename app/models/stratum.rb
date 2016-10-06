class Stratum < ActiveRecord::Base
  belongs_to :unit
  belongs_to :strat_type
  belongs_to :strat_occupation
  has_and_belongs_to_many :features
  has_and_belongs_to_many :soils
  
  def to_label
    "#{strat_all}"
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

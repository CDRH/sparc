class Stratum < ActiveRecord::Base
  belongs_to :unit
  belongs_to :strat_type
  belongs_to :occupation
  has_many :tree_rings
  has_and_belongs_to_many :bone_tools
  has_and_belongs_to_many :features
  has_and_belongs_to_many :select_artifacts

  def to_label
    "#{unit.to_label if unit} : #{strat_all} #{strat_alpha}"
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

class BoneTool < ActiveRecord::Base
  has_and_belongs_to_many :strata
  has_many :units, :through => :strata
  belongs_to :bone_tool_occupation
  
  def to_label
    "#{field_specimen_no}"
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

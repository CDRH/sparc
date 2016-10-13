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
  belongs_to :unit_occupation
  has_many :strata
  
  validates_uniqueness_of :unit_no

  def to_label
    "#{unit_no}"
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

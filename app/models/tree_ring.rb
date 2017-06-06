class TreeRing < ApplicationRecord
  belongs_to :occupation
  belongs_to :species_tree_ring
  belongs_to :stratum
  has_one :unit, -> {distinct}, :through => :stratum

  def self.sorted
    order("trl_no")
  end

  def to_label
    trl_no
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

class Ornament < ApplicationRecord
  belongs_to :occupation
  belongs_to :feature
  has_many :strata, -> {distinct}, :through => :feature
  has_many :units, -> {distinct}, :through => :strata

  def self.abstraction
    {
      assoc_input_type: "input",
      assoc_input_column: "salmon_museum_no"
    }
  end

  def self.sorted
    order("salmon_museum_no")
  end

  def to_label
    salmon_museum_no
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

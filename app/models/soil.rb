class Soil < ApplicationRecord
  belongs_to :art_type
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata

 def self.abstraction
    {
      assoc_input_type: "input",
      assoc_input_column: "sample_no"
    }
  end

  def self.sorted
    order("comments")
  end

  def to_label
    comments
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

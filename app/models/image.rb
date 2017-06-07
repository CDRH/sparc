class Image < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata
  has_many :zones, -> {distinct}, :through => :units
  has_many :occupations, -> {distinct}, :through => :units

  has_and_belongs_to_many :image_subjects
  belongs_to :image_assocnoeg
  belongs_to :image_box
  belongs_to :image_creator
  belongs_to :image_format
  belongs_to :image_human_remain
  belongs_to :image_orientation
  belongs_to :image_quality

  def self.sorted
    order("image_no")
  end

  def to_label
    image_no
  end

  def assocnoeg
    image_assocnoeg.name if image_assocnoeg
  end

  def box
    image_box.name if image_box
  end

  def creator
    image_creator.name if image_creator
  end

  def displayable?
    image_human_remain.displayable if image_human_remain
  end

  def format
    image_format.name if image_format
  end

  def human_remain
    image_human_remain.name if image_human_remain
  end

  def orientation
    image_orientation.name if image_orientation
  end

  def quality
    image_quality.name if image_quality
  end

  def occupation_list
    occupations.map {|o| o.name }
  end

  def subject_list
    image_subjects.map {|s| s.name }
  end

  def unit_list
    units.map {|u| u.unit_no }
  end

  def zone_list
    zones.map {|z| z.name }
  end


  # active scaffold / devise

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

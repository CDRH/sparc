class Image < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :strata, :through => :features
  has_many :units, :through => :strata

  has_and_belongs_to_many :image_subjects
  belongs_to :image_assocnoeg
  belongs_to :image_box
  belongs_to :image_creator
  belongs_to :image_format
  belongs_to :image_human_remain
  belongs_to :image_orientation
  belongs_to :image_quality

  def to_label
    image_no
  end

  def assocnoeg
    image_assocnoeg.name
  end

  def box
    image_box.name
  end

  def creator
    image_creator.name
  end

  def displayable?
    image_human_remain.displayable
  end

  def format
    image_format.name
  end

  def human_remain
    image_human_remain.name
  end

  def orientation
    image_orientation.name
  end

  def quality
    image_quality.name
  end

  def subject_list
    image_subjects.map {|s| s.subject }
  end

  def unit_list
    units.map {|u| u.unit_no }
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

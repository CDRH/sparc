class Image < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata
  has_many :zones, -> {distinct}, :through => :units

  has_and_belongs_to_many :image_subjects
  belongs_to :image_assocnoeg
  belongs_to :image_box
  belongs_to :image_creator
  belongs_to :image_format
  belongs_to :image_human_remain
  belongs_to :image_orientation
  belongs_to :image_quality

  if SETTINGS["hide_sensitive_image_records"]
    default_scope {
      joins(:image_human_remain).where("image_human_remains.name = ?", "N")
      where.not("images.comments LIKE ?", "%burial%")
    }
  end

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
    no_remains = true
    no_remains = image_human_remain.displayable if image_human_remain

    no_remains && !subject_list.include?("Feature-burial") &&
      !comments.downcase.include?("burial")
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

  def filepath
    loc = format == "polaroid" ? "polaroids" : "field"
    # strip PA[0] from front of image names
    # since database image_no does not match filesystem
    filename = image_no.gsub(/^PA0?/, "")
    "#{loc}/#{filename}.jpg"
  end

  def quality
    image_quality.name if image_quality
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

class Image < ActiveRecord::Base
  has_and_belongs_to_many :features
  has_many :strata, -> {distinct}, :through => :features
  has_many :units, -> {distinct}, :through => :strata
  has_many :zones, -> {distinct}, :through => :units

  has_and_belongs_to_many :image_subjects
  belongs_to :image_box
  belongs_to :image_creator
  belongs_to :image_format
  belongs_to :image_human_remain
  belongs_to :image_orientation
  belongs_to :image_quality

  if SETTINGS["hide_sensitive_image_records"]
    default_scope {
      joins(:image_human_remain).where(image_human_remains: { displayable: true })
    }
  end

  def self.abstraction
    {
      assoc_col: "image_no",
      description: <<-DESC,
The Images table was created by Nancy Espinosa, Emma Gibson, and other staff
members (of Salmon Ruins Museum) as part of Archaeology Southwest's Salmon
Project (2001-2018). This table contains data on images (photographic prints,
slides, polaroids from fieldwork, map transparencies, etc.) from the 1970s
Salmon Project. During the SPARC project (2015-2018), data within this table
were edited and cross-checked against other sources.
      DESC
      disabled: %w[],
      labels: {
        image_no: "Image Number",
        image_orientation: "Orientation",
        image_subjects: "Subjects"
      },
      primary: %w[
        image_no image_format image_orientation image_subjects comments
      ],
      selects: %w[image_format image_orientation image_subjects]
    }
  end

  def self.sorted
    order("images.image_no")
  end

  def to_label
    image_no
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
    no_remains && file_exists
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

end

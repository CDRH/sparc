class ImageOrientation < ActiveRecord::Base
  has_many :images

  validates_uniqueness_of :name

  def self.sorted
    order("image_orientations.name")
  end

  def to_label
    name
  end
end

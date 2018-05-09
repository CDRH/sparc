class ImageHumanRemain < ActiveRecord::Base
  has_many :images

  validates_uniqueness_of :name

  def self.sorted
    order("image_human_remains.name")
  end

  def to_label
    name
  end

end

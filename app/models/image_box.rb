class ImageBox < ActiveRecord::Base
  has_many :images

  validates_uniqueness_of :name

  def to_label
    name
  end
end

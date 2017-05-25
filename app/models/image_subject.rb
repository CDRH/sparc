class ImageSubject < ActiveRecord::Base
  has_and_belongs_to_many :images

  validates_uniqueness_of :name

  def self.sorted
    order("name")
  end

  def to_label
    name
  end

end

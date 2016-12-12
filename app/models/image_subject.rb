class ImageSubject < ActiveRecord::Base
  has_and_belongs_to_many :images

  validates_uniqueness_of :subject

  def self.sorted
    order("subject")
  end

  def to_label
    subject
  end

end

class ImageSubject < ActiveRecord::Base
  has_and_belongs_to_many :images

  validates_uniqueness_of :name

  if SETTINGS["hide_sensitive_image_records"]
    default_scope {
      where.not(name: "Feature-burial")
    }
  end

  def self.sorted
    order("name")
  end

  def to_label
    name
  end

end

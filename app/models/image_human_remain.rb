class ImageHumanRemain < ActiveRecord::Base
  before_save :set_displayable
  before_create :set_displayable

  has_many :images

  validates_uniqueness_of :name

  def to_label
    name
  end

  private

  def set_displayable
    self.displayable = self.name == "N" ? true : false
    # rails deprecation warning complaining about not returning
    # true on success, fixed below
    return true
  end
end

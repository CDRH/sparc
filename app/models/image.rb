class Image < ActiveRecord::Base
  belongs_to :feature
  has_many :strata, :through => :feature
  has_many :units, :through => :strata

  has_and_belongs_to_many :image_subjects

  def to_label
    image_no
  end
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

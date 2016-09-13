class Feature < ActiveRecord::Base
  has_many :codex_features
  has_many :codexes, :through => :codex_features
  has_many :rooms, :through => :codexes

  def to_label
    "#{feature_no}"
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

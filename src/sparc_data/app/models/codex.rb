class Codex < ActiveRecord::Base
  belongs_to :room
  has_many :codex_features
  has_many :features, :through => :codex_features
  
  def to_label
    "#{strat_all}"
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

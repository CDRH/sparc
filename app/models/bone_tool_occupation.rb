class BoneToolOccupation < ActiveRecord::Base
  def to_label
    "#{occupation}"
  end
end

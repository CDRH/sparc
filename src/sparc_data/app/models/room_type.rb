class RoomType < ActiveRecord::Base
  def to_label
    "#{description} #{period}"
  end
end

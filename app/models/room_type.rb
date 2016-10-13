class RoomType < ActiveRecord::Base
  has_many :units

  def to_label
    "#{description} #{period}"
  end
end

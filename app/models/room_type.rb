class RoomType < ActiveRecord::Base
  has_many :units

  def self.sorted
    order("description")
  end

  def to_label
    "#{description} #{period}"
  end
end

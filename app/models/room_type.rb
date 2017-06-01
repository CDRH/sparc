class RoomType < ActiveRecord::Base
  has_many :units
  belongs_to :occupation

  def self.sorted
    order("description")
  end

  def to_label
    if occupation
      "#{description} (#{occupation.name})"
    else
      description
    end
  end
end

class DoorwaySealed < ActiveRecord::Base
  def to_label
    "#{doorway_sealed}"
  end
end

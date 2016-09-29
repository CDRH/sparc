class EggshellItem < ApplicationRecord
  def to_label
    "#{item}"
  end
end

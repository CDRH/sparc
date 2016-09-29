class EggshellAffiliation < ApplicationRecord
  def to_label
    "#{affiliation}"
  end
end

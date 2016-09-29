class StratType < ActiveRecord::Base
  def to_label
    "#{strat_type}"
  end
end

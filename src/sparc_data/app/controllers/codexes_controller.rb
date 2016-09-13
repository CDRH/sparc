class CodexesController < ApplicationController

  active_scaffold :codex do |conf|
    conf.label = 'Strata'
    conf.columns[:room].label = 'Unit'
    conf.columns[:room_no].label = 'Unit no.'
    conf.columns = [:room, :room_no, :unit_type, :strat_all, :strat_alpha, :stratum_one, :stratum_two, :alias_strats, :original_period, :dominant_occupation, :comments, :features]
    conf.columns[:room].actions_for_association_links = [:show]
    conf.actions.swap :search, :field_search
  end

end

class Admin::StrataController < ApplicationController

  active_scaffold :stratum do |conf|
    # conf.columns[:room].label = 'Unit'
    # conf.columns[:room_no].label = 'Unit no.'
    conf.columns = [:unit, :strat_all, :strat_alpha, :strat_type, :stratum_one, :stratum_two, :strat_occupation, :features, :comments] #, :features, :bone_tools, :eggshells]
    conf.columns[:unit].actions_for_association_links = [:show]
    conf.columns[:strat_type].form_ui = :select
    conf.columns[:strat_occupation].form_ui = :select
    conf.actions.swap :search, :field_search
  end

  record_select :per_page => 10, :search_on => [:strat_all], :order_by => 'strat_all asc, strat_alpha asc'

end

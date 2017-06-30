class Admin::StrataController < ApplicationController

  active_scaffold :stratum do |conf|
    # conf.columns[:room].label = 'Unit'
    # conf.columns[:room_no].label = 'Unit no.'
    conf.columns = [:unit, :strat_all, :strat_alpha, :strat_type, :strat_grouping, :strat_one, :strat_two, :occupation, :features, :comments] #, :features, :faunal_tools, :eggshells]
    conf.columns[:unit].actions_for_association_links = [:show]
    conf.columns[:unit].form_ui = :record_select
    conf.columns[:features].form_ui = :record_select
    conf.columns[:strat_type].form_ui = :select
    conf.columns[:strat_grouping].form_ui = :select
    conf.columns[:occupation].form_ui = :select
    conf.actions.swap :search, :field_search
  end

  record_select :per_page => 10, :search_on => [:strat_all], :order_by => 'strat_all asc, strat_alpha asc'

end

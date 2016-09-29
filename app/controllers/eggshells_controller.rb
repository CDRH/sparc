class EggshellsController < ApplicationController

  active_scaffold :eggshell do |conf|
    conf.columns = [:room, :strat, :features, :salmon_museum_id_no, :record_field_key_no, :grid, :depth, :feature_no, :storage_bin, :museum_date, :field_date, :eggshell_affiliation, :eggshell_item]
    conf.columns[:eggshell_affiliation].form_ui = :select
    conf.columns[:eggshell_item].form_ui = :select
    conf.actions.swap :search, :field_search
  end


end

class Admin::EggshellsController < ApplicationController

  active_scaffold :eggshell do |conf|
    conf.columns = [:units, :strata, :features, :salmon_museum_no, :record_field_key_no, :grid, :depth, :feature_no, :storage_bin, :museum_date, :field_date, :eggshell_affiliation, :eggshell_item]
    conf.columns[:eggshell_affiliation].form_ui = :select
    conf.columns[:eggshell_item].form_ui = :select
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:features].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end


end

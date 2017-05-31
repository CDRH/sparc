class Admin::OrnamentsController < ApplicationController

  active_scaffold :ornament do |conf|
    conf.columns = [:units, :strata, :feature, :salmon_museum_no, :analysis_lab_no, :grid, :quad, :depth, :field_date, :occupation, :analyst, :analyzed, :photographer, :count, :item]
    conf.columns[:occupation].form_ui = :select
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:feature].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end


end

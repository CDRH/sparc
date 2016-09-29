class OrnamentsController < ApplicationController

  active_scaffold :ornament do |conf|
    conf.columns = [:room, :strat, :features, :museum_specimen_no, :analysis_lab_no, :grid, :quad, :depth, :field_date, :ornament_period, :analyst, :analyzed, :photographer, :count, :item]
    conf.columns[:ornament_period].form_ui = :select
    conf.actions.swap :search, :field_search
  end


end

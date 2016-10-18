class SoilsController < ApplicationController

  active_scaffold :soil do |conf|
    conf.columns = [:site, :units, :strata, :features, :fs, :box, :period, :soil_count, :gridew, :gridns, :quad, :exactprov, :depthbeg, :depthend, :otherstrat, :date, :excavator, :art_type, :sample_no, :comments, :data_entry, :location]
    conf.columns[:art_type].form_ui = :select
    conf.actions.swap :search, :field_search
  end

end

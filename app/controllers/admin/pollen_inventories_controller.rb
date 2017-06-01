class Admin::PollenInventoriesController < ApplicationController

  active_scaffold :pollen_inventory do |conf|
    conf.columns = [
      :unit,
      :strat,
      :strata,
      :strat_other,
      :features,
      :salmon_museum_no,
      :sa_no,
      :grid,
      :quad,
      :depth,
      :box,
      :record_field_key_no,
      :other_sample_no,
      :date,
      :analysis_completed,
      :frequency
    ]
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:features].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end

end

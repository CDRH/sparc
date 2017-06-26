class Admin::WoodInventoriesController < ApplicationController

  active_scaffold :wood_inventory do |conf|
    conf.columns = [
      :site,
      :unit,
      :strat,
      :strata,
      :strat_other,
      :features,
      :salmon_museum_no,
      :sa_no,
      :storage_location,
      :display,
      :grid,
      :quad,
      :depth,
      :record_field_key_no,
      :field_date,
      :lab,
      :analysis,
      :description,
      :select_artifact_info
    ]
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:features].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end

end

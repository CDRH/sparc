class Admin::BurialsController < ApplicationController

  active_scaffold :burial do |conf|
    conf.columns = [
      :units,
      :strata,
      :feature,
      :new_burial_no,
      :age,
      :burial_sex,
      :grid_ns,
      :grid_ew,
      :quad,
      :depth_begin,
      :depth_end,
      :date,
      :excavator,
      :record_field_key_no,
      :associated_artifacts,
      :description
    ]
    conf.columns[:occupation].form_ui = :select
    conf.columns[:burial_sex].form_ui = :select
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:feature].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end


end

class Admin::ImagesController < ApplicationController

  active_scaffold :image do |conf|
    conf.columns = [
      :units,
      :strata,
      :features,
      :image_format,
      :image_subjects,
      :image_creator,
      :comments,
      :notes,
      # organized alphabetically here on out
      :associated_features,
      :entered_by,
      :date,
      :depth_begin,
      :depth_end,
      :grid_ew,
      :grid_ns,
      :image_box,
      :image_human_remain,
      :image_no,
      :image_orientation,
      :image_quality,
      :other_no,
      :unit,
      :sa_no,
      :site,
      :storage_location,
      :strat,
    ]
    conf.columns[:features].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:units].form_ui = :record_select
    conf.columns[:image_subjects].form_ui = :select
    conf.actions.swap :search, :field_search
  end

  record_select :per_page => 10, :search_on => [:image_no]

end

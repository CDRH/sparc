class Admin::ImagesController < ApplicationController

  active_scaffold :image do |conf|
    conf.columns = [
      :units,
      :strata,
      :features,
      :format,
      :image_subjects,
      :creator,
      :comments,
      :notes,
      # organized alphabetically here on out
      :assocnoeg,
      :box,
      :data_entry,
      :date,
      :dep_beg,
      :dep_end,
      :gride,
      :gridn,
      :human_remains,
      :image_no,
      :image_quality,
      :image_type,
      :orientation,
      :other_no,
      :room,
      :signi_art_no,
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

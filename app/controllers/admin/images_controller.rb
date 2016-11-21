class Admin::ImagesController < ApplicationController

  active_scaffold :image do |conf|
    conf.columns = [
      :units,
      :strata,
      :feature,
      :assocnoeg,
      :box,
      :comments,
      :creator,
      :data_entry,
      :date,
      :dep_beg,
      :dep_end,
      :format,
      :gride,
      :gridn,
      :human_remains,
      :image_no,
      :image_quality,
      :image_type,
      :notes,
      :orientation,
      :other_no,
      :room,
      :signi_art_no,
      :site,
      :storage_location,
      :strat,
      :image_subjects
    ]
    conf.columns[:feature].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:units].form_ui = :record_select
    conf.columns[:image_subjects].form_ui = :record_select
    conf.actions.swap :search, :field_search
    conf.field_search.columns = conf.columns
  end

  record_select :per_page => 10, :search_on => [:image_no]

end

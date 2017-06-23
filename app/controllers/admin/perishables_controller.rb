class Admin::PerishablesController < ApplicationController

  active_scaffold :perishable do |conf|
    conf.columns = [:units, :strata, :features, :fs_no, :salmon_museum_number, :grid, :quad, :depth, :occupation, :sa_no, :artifact_type, :count, :artifact_structure, :comments, :comments_other, :storage_location, :exhibit_location, :record_field_key_no, :museum_lab_no, :field_date, :original_analysis, :select_artifact_info]
    conf.columns[:occupation].form_ui = :select
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:features].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end


end

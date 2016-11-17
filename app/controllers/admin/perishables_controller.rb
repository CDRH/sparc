class Admin::PerishablesController < ApplicationController

  active_scaffold :perishable do |conf|
    conf.columns = [:units, :strata, :features, :fs_number, :salmon_museum_number, :grid, :quad, :depth, :perishable_period, :sa_no, :artifact_type, :perishable_count, :artifact_structure, :comments, :other_comments, :storage_location, :exhibit_location, :record_key_no, :museum_lab_no, :field_date, :original_analysis]
    conf.columns[:perishable_period].form_ui = :select
    conf.actions.swap :search, :field_search
  end


end

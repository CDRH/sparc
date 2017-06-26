class Admin::CeramicVesselsController < ApplicationController
  ceramic_tables = [
    :ceramic_inventory,
    :ceramic_whole_vessel_form,
    :ceramic_vessel_lori_reed_form,
    :ceramic_vessel_type,
    :ceramic_vessel_lori_reed_type,
  ]

  active_scaffold :ceramic_vessel do |conf|
    conf.columns = [
      :units,
      :strata,
      :feature,
      :sa_no,
      :fs_no,
      :salmon_vessel_no,
      :pottery_order_no,
      :record_field_key_no,
      :vessel_percentage,
      :lori_reed_analysis,
      :comments_lori_reed,
      :comments_other,
      :select_artifact_info
    ]
    ceramic_tables.each do |t|
      conf.columns << t
      conf.columns[t].form_ui = :record_select
    end
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:feature].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end

end

class Admin::CeramicClapsController < ApplicationController
  ceramic_tables = [
    :ceramic_clap_type,
    :ceramic_clap_group_type,
    :ceramic_clap_temper,
    :ceramic_clap_tradition,
    :ceramic_clap_vessel_form,
  ]

  active_scaffold :ceramic_clap do |conf|
    conf.columns = [
      :units,
      :strata,
      :features,
      :record_field_key_no,
      :grid,
      :depth_begin,
      :depth_end,
      :field_year,
      :sherd_lot_no,
      :frequency,
      :comments
    ]
    ceramic_tables.each do |t|
      conf.columns << t
      conf.columns[t].form_ui = :select
    end
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:features].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end

end

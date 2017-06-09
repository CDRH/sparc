class Admin::CeramicsController < ApplicationController
  ceramic_tables = [
    :ceramic_inventory,
    :ceramic_vessel_form,
    :ceramic_vessel_part,
    :ceramic_exterior_pigment,
    :ceramic_interior_pigment,
    :ceramic_exterior_surface,
    :ceramic_interior_surface,
    :ceramic_vessel_appendage,
    :ceramic_temper,
    :ceramic_paste,
    :ceramic_slip,
    :ceramic_tradition,
    :ceramic_variety,
    :ceramic_ware,
    :ceramic_specific_type,
    :ceramic_style
  ]

  active_scaffold :ceramic do |conf|
    conf.columns = [
      :site,
      :fs_no,
      :lot_no,
      :cat_no,
      :units,
      :strata,
      :feature,
      :sa_no,
      :pulled_sample,
      :wall_thickness,
      :rim_radius,
      :rim_arc,
      :rim_eversion,
      :residues,
      :modification,
      :count,
      :weight,
      :vessel_no,
      :comments,
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

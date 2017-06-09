class Admin::LithicToolsController < ApplicationController
  ceramic_tables = [
    :lithic_inventory,
    :lithic_tool_artifact_type,
    :lithic_tool_material_type,
    :lithic_tool_condition,
    :lithic_tool_platform_type,
    :lithic_tool_termination
  ]

  active_scaffold :lithic_tool do |conf|
    conf.columns = [
      :units,
      :strata,
      :features,
      :artifact_no,
      :fire_altered,
      :utilized,
      :cortex_percentage,
      :cortical_flakes,
      :non_cortical_flakes,
      :length,
      :width,
      :thickness,
      :weight,
      :comments,
      :pii
    ]
    ceramic_tables.each do |t|
      conf.columns << t
      conf.columns[t].form_ui = :record_select
    end
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:features].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end

end

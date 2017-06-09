class Admin::BoneToolsController < ApplicationController

  active_scaffold :bone_tool do |conf|
    conf.columns = [
      :units,
      :strata,
      :fs_no,
      :bone_inventory,
      :depth,
      :occupation,
      :grid,
      :tool_type_code,
      :tool_type,
      :species_code,
      :comments
    ]
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:bone_inventory].form_ui = :record_select
    conf.columns[:occupation].form_ui = :select
    conf.actions.swap :search, :field_search
  end


end

class Admin::BoneToolsController < ApplicationController

  active_scaffold :bone_tool do |conf|
    conf.columns = [:units, :strata, :field_specimen_no, :depth, :bone_tool_occupation, :grid, :tool_type_code, :tool_type, :species_code, :comments]
    conf.columns[:bone_tool_occupation].form_ui = :select
    # conf.columns[:strata].form_ui = :record_select
    # conf.columns[:features].options = {:draggable_lists => true}
    conf.actions.swap :search, :field_search
  end


end

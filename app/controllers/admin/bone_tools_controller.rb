class Admin::BoneToolsController < ApplicationController

  active_scaffold :bone_tool do |conf|
    conf.columns = [:units, :strata, :fs_no, :depth, :occupation, :grid, :tool_type_code, :tool_type, :species_code, :comments]
    conf.columns[:occupation].form_ui = :select
    # conf.columns[:strata].form_ui = :record_select
    # conf.columns[:features].options = {:draggable_lists => true}
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end


end

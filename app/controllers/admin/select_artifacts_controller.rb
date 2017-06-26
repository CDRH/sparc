class Admin::SelectArtifactsController < ApplicationController

  active_scaffold :select_artifact do |conf|
    conf.columns = [:units, :strata, :features, :sa_no, :appears_in_table, :floor_association, :sa_form, :associated_feature_artifacts, :grid, :depth, :occupation, :select_artifact_type, :artifact_count, :location_in_room, :comments]
    conf.columns[:occupation].form_ui = :select
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:features].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end

end

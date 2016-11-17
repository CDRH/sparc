class Admin::SelectArtifactsController < ApplicationController

  active_scaffold :select_artifact do |conf|
    conf.columns = [:units, :strata, :artifact_no, :floor_association, :sa_form, :associated_feature_artifacts, :grid, :depth, :select_artifact_occupation, :select_artifact_type, :artifact_count, :location_in_room, :comments]
    conf.columns[:select_artifact_occupation].form_ui = :select
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end


end

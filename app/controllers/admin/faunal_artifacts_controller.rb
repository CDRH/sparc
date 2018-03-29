class Admin::FaunalArtifactsController < ApplicationController

  active_scaffold :faunal_artifact do |conf|
    conf.columns = [
      :units,
      :strata,
      :feature,
      :fs_no,
      :artifact_no,
      :faunal_inventory,
      :grid_ew,
      :grid_ns,
      :depth_begin,
      :depth_end,
      :spc,
      :elem,
      :side,
      :cond,
      :frag,
      :pd,
      :dv,
      :fuse,
      :burn,
      :art,
      :gnaw,
      :mod,
      :bmark,
      :frags,
    ]
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:feature].form_ui = :record_select
    conf.columns[:faunal_inventory].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end


end

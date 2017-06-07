class Admin::ObsidianInventoriesController < ApplicationController

  active_scaffold :obsidian_inventory do |conf|
    conf.columns = [
      :site,
      :box,
      :fs_no,
      :count,
      :unit,
      :strat,
      :strat_other,
      :strata,
      :feature,
      :lithic_id,
      :occupation,
      :obsidian_identified_source,
      :material_type,
      :shackley_sourcing,
      :grid_ew,
      :grid_ns,
      :quad,
      :exact_prov,
      :artifact_type,
      :depth_begin,
      :depth_end,
      :date,
      :excavator,
      :record_field_key_no,
      :comments,
      :entered_by,
      :location,
    ]
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:feature].form_ui = :record_select
    conf.columns[:occupation].form_ui = :select
    conf.columns[:obsidian_identified_source].form_ui = :select
    conf.actions.swap :search, :field_search
  end

end

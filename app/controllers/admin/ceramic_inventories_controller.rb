class Admin::CeramicInventoriesController < ApplicationController

  active_scaffold :ceramic_inventory do |conf|
    conf.columns = [:site, :units, :strata, :features, :fs_no, :box, :count, :grid_ew, :grid_ns, :quad, :exact_prov, :depth_begin, :depth_end, :strat_alpha, :strat_one, :strat_two, :strat_other, :field_date, :excavator, :art_type, :sa_no, :record_field_key_no, :comments, :entered_by, :location]
    conf.update.columns = [:site, :fs_no, :box, :count, :grid_ew, :grid_ns, :quad, :exact_prov, :depth_begin, :depth_end, :strat_alpha, :strat_one, :strat_two, :strat_other, :field_date, :excavator, :art_type, :sa_no, :record_field_key_no, :comments, :entered_by, :location]
    # conf.columns[:art_type].form_ui = :select
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.columns[:features].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end

end

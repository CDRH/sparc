class Admin::TreeRingsController < ApplicationController

  active_scaffold :tree_ring do |conf|
    conf.columns = [
      :site,
      :unit,
      :stratum,
      :occupation,
      :species_tree_ring,
      :record_field_key_no,
      :strat,
      :feature_no,
      :trl_no,
      :year_dated,
      :windes_sample,
      :field_no,
      :inner_date,
      :outer_date,
      :symbol,
      :cutting_date,
      :comments
    ]
    conf.columns[:occupation].form_ui = :select
    conf.columns[:unit].form_ui = :record_select
    conf.columns[:stratum].form_ui = :record_select
    conf.columns[:species_tree_ring].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end


end

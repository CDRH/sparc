class Admin::FeaturesController < ApplicationController

  active_scaffold :feature do |conf|
    
    conf.columns = [:units, :strata, :unit_no, :feature_no, :floor_association, :feature_form, :other_associated_features, :grid, :depth_m_b_d, :feature_occupation, :feature_type, :feature_count, :feature_group, :residential_feature, :location_in_room, :t_shaped_door, :door_between_multiple_room, :doorway_sealed, :length, :width, :depth_height, :comments]
    conf.columns[:feature_occupation].form_ui = :select
    conf.columns[:feature_type].form_ui = :select
    conf.columns[:feature_group].form_ui = :select
    conf.columns[:residential_feature].form_ui = :select
    conf.columns[:t_shaped_door].form_ui = :select
    conf.columns[:door_between_multiple_room].form_ui = :select
    conf.columns[:doorway_sealed].form_ui = :select
    conf.columns[:length].label  = 'Length'
    conf.columns[:width].label  = 'Width'
    conf.columns[:depth_height].label  = 'Depth/Height'
    conf.columns[:units].form_ui = :record_select
    conf.columns[:strata].form_ui = :record_select
    conf.actions.swap :search, :field_search
  end

  record_select :per_page => 10, :search_on => [:feature_no]

end

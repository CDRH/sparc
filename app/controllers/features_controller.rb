class FeaturesController < ApplicationController

  active_scaffold :feature do |conf|
    conf.columns[:rooms].label = 'Units'
    
    conf.columns = [:rooms, :codexes, :room_no, :feature_no, :strat, :floor_association, :feature_form, :other_associated_features, :grid, :depth_m_b_d, :occupation, :feature_type, :feature_count, :feature_group, :residentual_feature, :real_feature, :location_in_room, :t_shaped_door, :door_between_multiple_rooms, :doorway_sealed, :length_text, :width_text, :depth_height_text, :comments]
    conf.columns[:length_text].label  = 'Length'
    conf.columns[:width_text].label  = 'Width'
    conf.columns[:depth_height_text].label  = 'Depth/Height'
    conf.columns[:codexes].label = 'Strata'
    conf.actions.swap :search, :field_search
  end


end

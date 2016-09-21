class RoomsController < ApplicationController

  active_scaffold :room do |conf|
    conf.label = 'Units'
    conf.columns[:room_no].label = 'Unit no.'
    conf.columns = [:room_no, :excavation_status, :occupation, :room_class, :stories, :intact_roof, :room_type, :type_description, :inferred_function, :salmon_sector, :other_desc, :irregular_shape, :length_text, :width_text, :floor_area_text, :comments, :codexes]
    conf.columns[:codexes].label = 'Strata'
    # conf.columns[:regiment].form_ui = :record_select
    conf.columns[:room_type].form_ui = :record_select
    conf.columns[:room_type].actions_for_association_links = [:show]
    conf.columns[:other_desc].options = {:rows => 5, :cols => 60}
    conf.columns[:comments].options = {:rows => 5, :cols => 60}
    conf.actions.swap :search, :field_search
    # conf.field_search.columns = [:room_no, :excavation_status, :occupation, :room_class, :stories, :intact_roof, :room_type, :type_description, :inferred_function, :salmon_sector, :other_desc, :irregular_shape, :length_text, :width_text, :floor_area_text, :comments, :codexes]
  end

  record_select :per_page => 10, :search_on => [:room_no]

end

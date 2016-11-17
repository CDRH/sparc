class Admin::UnitsController < ApplicationController

  active_scaffold :unit do |conf|
    conf.label = 'Units'
    conf.columns = [:unit_no, :excavation_status, :unit_occupation, :unit_class, :story, :intact_roof, :room_type, :type_description, :inferred_function, :salmon_sector, :other_description, :irregular_shape, :length, :width, :floor_area, :comments, :strata]
    conf.update.columns = [:unit_no, :excavation_status, :unit_occupation, :unit_class, :story, :intact_roof, :room_type, :type_description, :inferred_function, :salmon_sector, :other_description, :irregular_shape, :length, :width, :floor_area, :comments]
    # conf.columns[:codexes].label = 'Strata'
    conf.columns[:excavation_status].form_ui = :select
    conf.columns[:unit_occupation].form_ui = :select
    conf.columns[:unit_class].form_ui = :select
    conf.columns[:story].form_ui = :select
    conf.columns[:intact_roof].form_ui = :select
    conf.columns[:room_type].form_ui = :select
    conf.columns[:type_description].form_ui = :select
    conf.columns[:inferred_function].form_ui = :select
    conf.columns[:salmon_sector].form_ui = :select
    conf.columns[:irregular_shape].form_ui = :select
    conf.columns[:room_type].form_ui = :record_select
    conf.columns[:room_type].actions_for_association_links = [:show]
    # conf.columns[:other_desc].options = {:rows => 5, :cols => 60}
    # conf.columns[:comments].options = {:rows => 5, :cols => 60}

    conf.columns[:strata].form_ui = :record_select

    conf.actions.swap :search, :field_search
    # conf.field_search.columns = [:room_no, :excavation_status, :occupation, :room_class, :stories, :intact_roof, :room_type, :type_description, :inferred_function, :salmon_sector, :other_desc, :irregular_shape, :length_text, :width_text, :floor_area_text, :comments, :codexes]
    conf.field_search.columns = [:unit_no, :excavation_status, :unit_occupation] #, :unit_class, :story, :intact_roof, :room_type, :type_description, :inferred_function, :salmon_sector, :other_description, :irregular_shape, :length, :width, :floor_area, :comments, :strata]
  end

  record_select :per_page => 10, :search_on => [:unit_no]

end

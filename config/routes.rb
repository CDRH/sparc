Rails.application.routes.draw do

  devise_for :users

  tables = [
    :bone_tools,
    :eggshells,
    :features,
    :ornaments,
    :perishables,
    :room_types,
    :select_artifacts,
    :soils,
    :strata,
    :units,
  ]

  tables.each do |table|
    resources table do
      as_routes
      record_select_routes
      add_as_extension table
    end
  end

  # activescaffold_extensions(:rooms)

  root 'units#index'

end

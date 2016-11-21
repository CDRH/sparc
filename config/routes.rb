Rails.application.routes.draw do

  devise_for :users

  tables = [
    :bone_inventories,
    :bone_tools,
    :ceramic_inventories,
    :eggshells,
    :features,
    :images,
    :lithic_inventories,
    :ornaments,
    :perishables,
    :room_types,
    :select_artifacts,
    :soils,
    :strata,
    :units,
  ]

  tables.each do |table|
    namespace :admin do
      get '/', to: 'units#index'
      resources table do
        # as_routes is deprecated but for some reason its replacement isn't working for me
        as_routes
        record_select_routes
        add_as_extension table
      end
    end
  end

  # activescaffold_extensions(:rooms)

  get '/', to: 'static#index', as: :home
end

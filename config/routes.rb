Rails.application.routes.draw do

  devise_for :users
  get '/', to: 'static#index', as: :home
  get '/explore', to: 'static#explore', as: :explore
  get '/search', to: 'static#search', as: :search
  get '/query', to: 'static#query', as: :query
  get '/gallery', to: 'static#gallery', as: :gallery
  get '/about', to: 'static#about', as: :about


  tables = [
    :lithic_inventories,
    :bone_inventories,
    :ceramic_inventories,
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
    namespace :admin do
      resources table do
        # as_routes is deprecated but for some reason its replacement isn't working for me
        as_routes
        record_select_routes
        add_as_extension table
      end
    end
  end

  # activescaffold_extensions(:rooms)

end

Rails.application.routes.draw do

  devise_for :users

  get '/', to: 'static#index', as: :home
  # explore
  get '/explore', to: 'explore#index', as: :explore
  get '/explore/early-links', to: 'explore#early-links', as: :explore_e_links
  get '/explore/early-links-numbered', to: 'explore#early-links-numbered', as: :explore_e_links_num
  get '/explore/early-zoom', to: 'explore#early-zoom', as: :explore_e_zoom
  get '/explore/early-zoom-links', to: 'explore#early-zoom-links', as: :explore_e_zoom_links
  get '/explore/early', to: 'explore#early', as: :explore_e
  get '/explore/late', to: 'explore#late', as: :explore_l
  get '/explore/late-zoom', to: 'explore#late-zoom', as: :explore_l_zoom
  # search and browse
  get '/search', to: 'static#search', as: :search
  get '/search/unit/:id', to: 'search#unit', as: :unit
  get '/search/zone/:id', to: 'search#zone', as: :search_zone

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

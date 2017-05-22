Rails.application.routes.draw do

  devise_for :users

  get '/', to: 'static#index', as: :home
  # documents
  get '/documents', to: 'documents#index', as: :documents
  # explore
  get '/explore', to: 'explore#index', as: :explore
  get '/explore/early-zoom', to: 'explore#early-zoom', as: :explore_e_zoom
  get '/explore/early-zoom-links', to: 'explore#early-zoom-links', as: :explore_e_zoom_links
  get '/explore/late', to: 'explore#late', as: :explore_l
  get '/explore/late-zoom', to: 'explore#late-zoom', as: :explore_l_zoom
  # images
  get '/gallery', to: 'image#index', as: :gallery
  get '/gallery/:number', to: 'image#show', as: :image
  # search and browse
  get '/query', to: 'query#index', as: :query
  get '/query/unit/:number', to: 'query#unit', as: :unit
  get '/query/zone/:number', to: 'query#zone', as: :search_zone
  # placeholders
  get '/about', to: 'static#about', as: :about


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
    :zones
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

end

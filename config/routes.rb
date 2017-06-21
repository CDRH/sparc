Rails.application.routes.draw do

  devise_for :users

  get '/', to: 'static#index', as: :home
  # documents
  get '/documents', to: 'document#index', as: :documents
  get '/documents/type/:type', to: 'document#type', as: :documents_type
  get '/documents/unit/:unit(/:type)', to: 'document#unit', as: :documents_unit
  # explore
  get '/explore', to: 'explore#index', as: :explore
  get '/explore/early-zoom', to: 'explore#early-zoom', as: :explore_e_zoom
  get '/explore/early-zoom-links', to: 'explore#early-zoom-links', as: :explore_e_zoom_links
  get '/explore/late', to: 'explore#late', as: :explore_l
  get '/explore/late-zoom', to: 'explore#late-zoom', as: :explore_l_zoom
  get '/explore/units', to: 'explore#units', as: :units
  get '/explore/unit/:number', to: 'explore#unit', as: :unit
  get '/explore/zone/:number', to: 'explore#zone', as: :search_zone
  # images
  get '/gallery', to: 'image#index', as: :gallery
  get '/gallery/:number', to: 'image#show', as: :image
  # search and browse
  get '/query', to: 'query#index', as: :query
  get '/query/artifacts', to: 'query#artifacts', as: :artifacts
  get '/query/artifacts/bones', to: 'query#bones', as: :bones
  get '/query/artifacts/ceramics', to: 'query#ceramics', as: :ceramics
  get '/query/artifacts/eggshells', to: 'query#eggshells', as: :eggshells
  get '/query/artifacts/lithics', to: 'query#lithics', as: :lithics
  get '/query/artifacts/ornaments', to: 'query#ornaments', as: :ornaments
  get '/query/artifacts/perishables', to: 'query#perishables', as: :perishables
  get '/query/artifacts/soils', to: 'query#soils', as: :soils
  get '/query/artifacts/woods', to: 'query#woods', as: :woods
  # placeholders
  get '/about', to: 'static#about', as: :about


  tables = [
    :bone_inventories,
    :bone_tools,
    :burials,
    :ceramics,
    :ceramic_claps,
    :ceramic_inventories,
    :ceramic_vessels,
    :documents,
    :eggshells,
    :features,
    :images,
    :lithic_debitages,
    :lithic_inventories,
    :lithic_tools,
    :obsidian_inventories,
    :ornaments,
    :perishables,
    :pollen_inventories,
    :room_types,
    :select_artifacts,
    :soils,
    :strata,
    :tree_rings,
    :units,
    :wood_inventories,
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

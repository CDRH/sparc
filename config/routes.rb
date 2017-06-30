Rails.application.routes.draw do

  devise_for :users

  get '/', to: 'static#index', as: :home
  # documents
  get '/documents', to: 'document#index', as: :documents
  get '/documents/type/:type', to: 'document#type', as: :documents_type
  get '/documents/unit/:unit(/:type)', to: 'document#unit', as: :documents_unit
  # explore
  get '/explore', to: 'explore#index', as: :explore
  get '/explore/early-zoom', to: 'explore#early_zoom', as: :explore_e_zoom
  get '/explore/early-zoom-links', to: 'explore#early_zoom_links', as: :explore_e_zoom_links
  get '/explore/late', to: 'explore#late', as: :explore_l
  get '/explore/late-zoom', to: 'explore#late_zoom', as: :explore_l_zoom
  get '/explore/units', to: 'explore#units', as: :units
  get '/explore/unit/:number', to: 'explore#unit_summary', as: :unit
  get '/explore/unit/:number/overview', to: 'explore#unit_overview', as: :unit_overview
  get '/explore/unit/:number/images', to: 'explore#unit_images', as: :unit_images
  get '/explore/unit/:number/documents', to: 'explore#unit_documents', as: :unit_documents
  get '/explore/unit/:number/strata', to: 'explore#unit_strata', as: :unit_strata
  get '/explore/unit/:number/features', to: 'explore#unit_features', as: :unit_features
  get '/explore/zone/:number', to: 'explore#zone', as: :search_zone
  # images
  get '/gallery', to: 'image#index', as: :gallery
  get '/gallery/:number', to: 'image#show', as: :image

  # Query
  get '/query', to: 'query#index', as: :query
  get '/query/:category', to: 'query#category', as: :query_category
  get '/query/:category/:type(/:table)', to: 'query#form', as: :query_form
  get '/query/:category/:type/:table/results', to: 'query#results', as: :query_results

  # placeholders
  get '/about', to: 'static#about', as: :about


  tables = [
    :burials,
    :ceramics,
    :ceramic_claps,
    :ceramic_inventories,
    :ceramic_vessels,
    :documents,
    :eggshells,
    :faunal_inventories,
    :faunal_tools,
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

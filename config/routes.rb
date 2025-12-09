Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/', to: 'static#index', as: :home

  # Documents
  get '/documents', to: 'document#index', as: :documents
  get '/documents/unit/:unit(/:type)', to: 'document#unit',
      as: :documents_unit

  # Errors
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  # Explore
  get '/explore', to: 'explore#index', as: :explore
  get '/explore/map', to: 'explore#map', as: :map
  get '/explore/units', to: 'explore#units', as: :units
  get '/explore/unit/:number', to: 'explore#unit_summary', as: :unit
  get '/explore/unit/:number/overview', to: 'explore#unit_overview',
      as: :unit_overview
  get '/explore/unit/:number/images', to: 'explore#unit_images',
      as: :unit_images
  get '/explore/unit/:number/documents', to: 'explore#unit_documents',
      as: :unit_documents
  get '/explore/unit/:number/strata', to: 'explore#unit_strata',
      as: :unit_strata
  get '/explore/unit/:number/associated', to: 'explore#unit_associated',
      as: :unit_associated
  get '/explore/zone/:number', to: 'explore#zone', as: :search_zone

  # Images
  get '/gallery', to: 'image#index', as: :gallery
  get '/gallery/:number', to: 'image#show', as: :image

  # Query
  get '/query', to: 'query#index', as: :query
  get '/query/other', to: 'query#other', as: :query_other
  get '/query/:category', to: 'query#category', as: :query_category
  get '/query/:category/:subcat(/:table)', to: 'query#form', as: :query_form
  get '/query/:category/:subcat/:table/results', to: 'query#results',
      as: :query_results

  # Static Pages
  get '/about', to: 'static#about', as: :about
  get '/about/:name', to: 'static#about_sub', as: :about_sub
  get '/native-descendants', to: 'static#descendants', as: :descendants

end

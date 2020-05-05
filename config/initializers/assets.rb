# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# maps
Rails.application.config.assets.precompile += %w(
  svg-pan-zoom.js
  map_zoom.js
  maps.css
)

# query
Rails.application.config.assets.precompile += %w(
  query
)

# documents
Rails.application.config.assets.precompile += %w( 
  uv2.0.2/lib/bundle.min.js
  uv2.0.2/lib/app.js
  uv2.0.2/lib/embed.js
  uv2.0.2/require.min.js
  document_iiif_viewer.js
)

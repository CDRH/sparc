# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )


# active scaffold
# Note: active_scaffold.css is coming from the active_scaffold gem
Rails.application.config.assets.precompile += %w(
  active_scaffold.css
  active_scaffold.js
  active_scaffold_customization.css
  scaffolds.scss
)

# images
Rails.application.config.assets.precompile += %w(
  ekko-lightbox.min.css
  ekko-lightbox.min.js
  images.css
)

# maps
Rails.application.config.assets.precompile += %w(
  svg-pan-zoom.js
  map_zoom.js
  maps.css
)

Rails.application.config.assets.precompile += %w( 
  uv-2.0.2/lib/bundle.min.js
  uv-2.0.2/lib/app.js
  uv-2.0.2/lib/embed.js
  uv-2.0.2/require.min.js
  document_iiif_viewer.js
)

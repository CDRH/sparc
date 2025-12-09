source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 4.2.0'
# Use CoffeeScript for .coffee assets and views
# TODO update to 5.0?
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 1.0.0', group: :doc

# bootsnap reduces load times, added in ruby 5.2
gem 'bootsnap'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'listen'

  # will kill postgres processes related to the database connection
  # which allows for the database to be dropped even when using phusion passenger
  gem 'pgreset'
end

# postgres database for active record
gem "pg"

gem 'bootstrap-sass'

# spreadsheet parsing tools
gem 'roo'
gem 'roo-xls'

# metadata parser for documents
# Note: above requires exiftool installed on system: http://www.sno.phy.queensu.ca/~phil/exiftool/
gem 'mini_exiftool'

# pagination
gem 'will_paginate'

# iiif presentation
# using stanford fork of original osullivan library, since it is supported
gem "iiif-presentation", "~> 0.2.0", github: "sul-dlss/osullivan", ref: "1f3c9fd96d34fc67405bd412f6470bef8ca3a455"

# Temp constraint on Psych for config file alias compatibility
gem 'psych', '< 4.0.0'

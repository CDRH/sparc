source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.6'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
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
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # will kill postgres processes related to the database connection
  # which allows for the database to be dropped even when using phusion passenger
  gem 'pgreset'

  # create favicon
  gem 'rails_real_favicon'
end

# postgres database for active record
gem "pg", ">= 0.18", "< 1.0"
# active scaffold sets up the table views
gem 'active_scaffold', :git => 'https://github.com/activescaffold/active_scaffold.git', :tag => 'v3.5.0'
gem 'recordselect', :git => 'https://github.com/scambra/recordselect.git'

gem 'devise'
gem 'bootstrap-sass'

gem 'kaminari'
gem 'activerecord-session_store'

# spreadsheet parsing tools
gem 'roo'
gem 'roo-xls'

# metadata parser for documents
# Note: above requires exiftool installed on system: http://www.sno.phy.queensu.ca/~phil/exiftool/
gem 'mini_exiftool'

# pagination
gem 'will_paginate'

# iiif presentation
gem 'osullivan'

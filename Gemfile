source 'https://rubygems.org'

ruby "2.3.1"

gem 'rake', '12.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'rocket_tag', git: 'https://github.com/satoriapp/rocket_tag.git'
gem 'ransack'                     # build filter queries for contacts etc.
gem 'will_paginate'
gem 'will_paginate-bootstrap'     # compatibility patch for CSS. might be obsolete now?
gem 'haml'
gem 'tabs_on_rails'               # render the main navigation bars.
gem 'rdiscount'


gem 'rspec', '>= 2.14.0'                  # Let's write some specs!
gem 'rspec-rails', '>= 2.14.2'            # RSpec example mixins for Rails.
gem 'rspec-mocks', '>= 2.14.0'            # RSpec mocks.
gem 'rspec-its'
gem 'rspec-activemodel-mocks'          # Mocking for ActiveRecord classes.
gem 'rspec-example_steps'              # Given/When/Then DSL for acceptance tests.

gem 'factory_girl_rails', '>= 4.4.0'   # Factories for unit tests.
gem 'database_cleaner'                 # Clean up the database after each test.

# WEBDRIVERS

gem 'rack-test'

group :test do
  gem 'capybara'                     # Acceptance test web driver.
  gem 'site_prism'                   # Page Object DSL for acceptance tests.
  gem 'vcr'                          # Record and playback HTTP requests to make tests faster.
  gem 'show_me_the_cookies'          # Testing cookies.
  gem 'timecop'                      # Stub the current time functions.
  gem 'webmock'
  gem 'approvals'
end


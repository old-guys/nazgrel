source 'https://gems.ruby-china.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 5.2', '>= 5.2.0'
gem 'rails', '>= 5.2.0.rc1', "< 6.0"

# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.4.10'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Adds cache_collection! to jbuilder. Uses memcache fetch_multi/read_multi
gem 'jbuilder_cache_multi', '~> 0.1.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# The fastest JSON parser and object serializer.
gem 'oj', '~> 3.5'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.0', '>= 1.0.2'

# Kaminari is a Scope & Engine based, clean, powerful, agnostic, customizable
# and sophisticated paginator for Rails 4+
gem 'kaminari', '~> 1.1', '>= 1.1.1'

# Extend ActiveRecord pluck to return hash instead of an array.
# Useful when plucking multiple columns.
gem 'pluck_to_hash', '~> 1.0', '>= 1.0.2'

# Help ActiveRecord::Enum feature to work fine with I18n and simple_form.
gem 'enum_help', '~> 0.0.17'
# Enumerated attributes with I18n and ActiveRecord/Mongoid/MongoMapper support
# gem 'enumerize', '~> 2.1', '>= 2.1.2'


# A set of common locale data and translations to internationalize and/or
# localize your Rails applications.
gem 'rails-i18n', '~> 5.1', '>= 5.1.1'

# Add schema comments in your migrations,
# see them in model annotations and db/schema.rb dump
gem 'migration_comments', '~> 0.4', '>= 0.4.1'

# Makes http fun! Also, makes consuming restful web services dead easy.
gem 'httparty', '~> 0.16', '>= 0.16.1'

# Axlsx_Rails provides an Axlsx renderer
# so you can move all your spreadsheet code from your controller into view files.
# gem 'axlsx_rails', '~> 0.5.1'
# xlsx spreadsheet generation with charts, images,
# automated column width, customizable styles and full schema validation.
# gem 'axlsx', '~> 2.1.0.pre'
gem 'axlsx', '~> 3.0.0.pre'

######## foreign service  ########
# RequestStore gives you per-request global storage.
gem 'request_store', '~> 1.4'
# Clean ruby syntax for writing and deploying cron jobs.
gem 'whenever', '~> 0.10', '>= 0.10.0', require: false

# Qiniu Resource (Cloud) Storage SDK for Ruby.
# See: http://developer.qiniu.com/docs/v6/sdk/ruby-sdk.html
gem 'qiniu', '~> 6.9'

#### authorization  #####
# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 4.4', '>= 4.4.1'
# Time Based OTP/rfc6238 compatible authentication for Devise
# gem 'devise-otp', '~> 0.1.1'
# Translations for the devise gem
gem 'devise-i18n', '~> 1.6', '>= 1.6.1'
# Object oriented authorization for Rails applications
gem 'pundit', '~> 1.1', '>= 1.1.0'

########  framework  base support ########
# Simple, efficient background processing for Ruby.
gem 'sidekiq', '~> 5.1', '>= 5.1.1'

# Enables to set jobs to be run in specified time (using CRON notation)
gem 'sidekiq-cron', '~> 0.6', '>= 0.6.3'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.2.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  # gem 'web-console', '~> 3.5', '>= 3.5.1'
  # gem 'listen', '~> 3.1', '>= 3.1.5'

  # bundler-audit provides patch-level verification for Bundled apps.
  # gem 'bundler-audit', '~> 0.6', '>= 0.6'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.0', '>= 2.0.2'
  gem 'spring-watcher-listen', '~> 2.0', '>= 2.0.1'
end

# Use unicorn as the app server
group :production do
  # unicorn is an HTTP server for Rack applications designed to only serve fast
  # clients on low-latency, high-bandwidth connections and take advantage of
  # features in Unix/Unix-like kernels.
  gem 'unicorn', '~> 5.4', '>= 5.4.0'
  # raindrops is a real-time stats toolkit to show statistics
  # for Rack HTTP servers.
  gem 'raindrops', '~> 0.19', '>= 0.19.0'
  # Kill unicorn workers by memory and request counts
  gem 'unicorn-worker-killer', '~> 0.4', '>= 0.4.4'
  # New Relic is a performance management system,
  # developed by New Relic, Inc (http://www.newrelic.com)
  gem 'newrelic_rpm', '~> 4.8', '>= 4.8.0.341'
end

# Use Capistrano for deployment
group :development do
  # Rails specific Capistrano tasks
  gem 'capistrano-rails', '~> 1.3', '>= 1.3.1'
  # Unicorn specific Capistrano tasks
  gem 'capistrano3-unicorn', '~> 0.2', '>= 0.2.1'
  # RVM integration for Capistrano
  gem 'capistrano-rvm', '~> 0.1', '>= 0.1.2'
  gem 'capistrano-sidekiq', '~> 1.0'
end

# group :test do
#   # Adds support for Capybara system testing and selenium driver
#   gem 'capybara', '~> 2.15'
#   gem 'selenium-webdriver'
#   # Easy installation and use of chromedriver to run system tests with Chrome
#   gem 'chromedriver-helper'
# end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
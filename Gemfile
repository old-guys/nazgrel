source 'https://gems.ruby-china.org'
ruby "2.5.0"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1', '>= 5.1.4'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Adds cache_collection! to jbuilder. Uses memcache fetch_multi/read_multi
gem 'jbuilder_cache_multi', '~> 0.1.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# The fastest JSON parser and object serializer.
gem 'oj', '~> 3.3', '>= 3.3.10'

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
gem 'enumerize', '~> 2.1', '>= 2.1.2'

# Add schema comments in your migrations,
# see them in model annotations and db/schema.rb dump
gem 'migration_comments', '~> 0.4', '>= 0.4.1'

# Print stack trace of all queries to the Rails log.
# Helpful to find where queries are being executed in your application.
gem 'active_record_query_trace', '~> 1.5', '>= 1.5.4'

# Makes http fun! Also, makes consuming restful web services dead easy.
gem 'httparty', '~> 0.15', '>= 0.15.6'

######## foreign service  ########
# RequestStore gives you per-request global storage.
gem 'request_store', '~> 1.4'
# Clean ruby syntax for writing and deploying cron jobs.
gem 'whenever', '~> 0.10', '>= 0.10.0', require: false

#### authorization  #####
# Flexible authentication solution for Rails with Warden
gem 'devise', '~> 4.4'
# Time Based OTP/rfc6238 compatible authentication for Devise
# gem 'devise-otp', '~> 0.1.1'
# Translations for the devise gem
gem 'devise-i18n', '~> 1.5', '>= 1.5.0'
# Object oriented authorization for Rails applications
gem 'pundit', '~> 1.1', '>= 1.1.0'

########  framework  base support ########
# Redis for Ruby on Rails
gem 'redis-rails', '~> 5.0', '>= 5.0.2'

# Simple, efficient background processing for Ruby.
gem 'sidekiq', '~> 5.0', '>= 5.0.5'

# Enables to set jobs to be run in specified time (using CRON notation)
gem 'sidekiq-cron', '~> 0.6', '>= 0.6.3'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.1', platforms: [:mri, :mingw, :x64_mingw]

  # help to kill N+1 queries and unused eager loading
  gem 'bullet', '~> 5.7', '>= 5.7.0'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '~> 3.5', '>= 3.5.1'
  gem 'listen', '~> 3.1', '>= 3.1.5'

  # bundler-audit provides patch-level verification for Bundled apps.
  gem 'bundler-audit', '~> 0.6', '>= 0.6'
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
  gem 'newrelic_rpm', '~> 4.6', '>= 4.6.0.338'
end

# Use Capistrano for deployment
group :development do
  # Rails specific Capistrano tasks
  gem 'capistrano-rails', '~> 1.3', '>= 1.3.0'
  # Unicorn specific Capistrano tasks
  gem 'capistrano3-unicorn', '~> 0.2', '>= 0.2.1'
  # RVM integration for Capistrano
  gem 'capistrano-rvm', '~> 0.1', '>= 0.1.2'
  gem 'capistrano-sidekiq', '~> 0.20', '>= 0.20.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'rails-i18n'

gem 'qiniu', '>= 6.9.0'
gem 'axlsx_rails', '~> 0.5.1'
gem 'axlsx', '~> 2.1.0.pre'
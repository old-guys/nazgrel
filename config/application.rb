require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Nazgrel
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Timezone
    config.time_zone = 'Beijing'

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Models are organized in sub-directories
    # FIXME namespace directories should not autoload
    # config.autoload_paths += Dir[Rails.root.join("app/models/**")] +
    #                         Dir[Rails.root.join("app/controllers/entities")]
    config.autoload_paths += Dir[Rails.root.join("app/models/users")] +
                               Dir[Rails.root.join("app/models/authorizations")] +
                               Dir[Rails.root.join("app/models/reports")] +
                               Dir[Rails.root.join("app/models/channels")] +
                               Dir[Rails.root.join("app/models/sesame_mall")] +
                               Dir[Rails.root.join("app/models/settings")] +
                               Dir[Rails.root.join("app/services")] +
                               Dir[Rails.root.join("app/seeks")] +
                               Dir[Rails.root.join("app/seeks/concerns")] +
                               Dir[Rails.root.join("app/reports")] +
                               Dir[Rails.root.join("app/reports/concerns")] +
                               Dir[Rails.root.join("app/workers/seeks")] +
                               Dir[Rails.root.join("app/workers/reports")]

    ::SERVICES_CONFIG = OpenStruct.new(config_for(:services))

    config.middleware.delete Rack::Sendfile
    config.middleware.delete Rack::Head
    config.middleware.delete Rack::ConditionalGet
    config.middleware.delete ActionDispatch::Cookies
    config.middleware.delete ActionDispatch::Session::CookieStore
    config.middleware.delete ActionDispatch::Flash
    config.middleware.delete Rack::ETag
  end
end
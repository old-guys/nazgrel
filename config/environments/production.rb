Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  # config.active_storage.service = :local

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  log_conf = SERVICES_CONFIG['log']
  if log_conf.present?
    config.log_level = log_conf.fetch("level", :debug)

    # Prepend all log lines with the following tags.
    config.log_tags = log_conf.fetch("tags", [:uuid])
  end

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store
  # https://github.com/rails/rails/issues/29489
  redis_conf = SERVICES_CONFIG['redis']
  if redis_conf
    _url = redis_conf['url']
    _url ||= if redis_conf['password']
       "redis://:#{redis_conf['password']}@#{redis_conf['host']}:#{redis_conf['port']}/#{redis_conf['cache_db']}"
    else
       "redis://#{redis_conf['host']}:#{redis_conf['port']}/#{redis_conf['cache_db']}"
    end

    config.cache_store = :redis_cache_store, {
      url: _url,
      expires_in: redis_conf['expires_in'] || 5.days
    }
  end

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "nazgrel_#{Rails.env}"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Highlight code that triggered database queries in logs.
  if SERVICES_CONFIG["verbose_query_logs"].to_s == "true"
    config.active_record.verbose_query_logs = true
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
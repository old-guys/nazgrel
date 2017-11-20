if SERVICES_CONFIG["log_cache"]
  Rails.cache.logger = Rails.logger
end

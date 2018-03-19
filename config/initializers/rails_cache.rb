if SERVICES_CONFIG["log_cache"].to_s == "true"
  Rails.cache.logger = Rails.logger
end
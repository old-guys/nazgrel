require 'sidekiq/middleware/memory_gc'
require 'sidekiq/middleware/request_store'

redis_config = {
  host: SERVICES_CONFIG.redis[:host],
  port: SERVICES_CONFIG.redis[:port],
  password: SERVICES_CONFIG.redis[:password],
  db: SERVICES_CONFIG.redis[:job_db],
}

Sidekiq.configure_server do |config|
  config.redis = redis_config
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::MemoryGc

    if defined?(RequestStore)
      chain.add Sidekiq::Middleware::RequestStore
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

Sidekiq.default_worker_options = {
  "retry"     => false,
  "queue"     => "default",
  "backtrace" => true
}

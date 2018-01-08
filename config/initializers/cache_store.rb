# Be sure to restart your server when you modify this file.

Rails.application.configure do
  redis_conf = SERVICES_CONFIG['redis']
  config.cache_store = :redis_store, {
    host: redis_conf['host'],
    port: redis_conf['port'],
    db: redis_conf['cache_db'],
    password: redis_conf['password'],
    expires_in: 2.days
  }
end
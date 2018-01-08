# Be sure to restart your server when you modify this file.

# https://github.com/rails/rails/issues/29489
redis_conf = SERVICES_CONFIG['redis']
Rails.cache = ActiveSupport::Cache.lookup_store(:redis_store, {
  host: redis_conf['host'],
  port: redis_conf['port'],
  db: redis_conf['cache_db'],
  password: redis_conf['password'],
  expires_in: redis_conf['expires_in'] || 5.days
})
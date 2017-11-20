$redis = Redis.new(
  host: SERVICES_CONFIG.redis["host"],
  port: SERVICES_CONFIG.redis["port"],
  password: SERVICES_CONFIG.redis["password"],
  db: SERVICES_CONFIG.redis["data_db"]
)

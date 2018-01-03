module ActionUtilable
  extend ActiveSupport::Concern

  included do
  end
  private
  def action_cache_key(*key)
    key = Array.wrap(key)
    key.insert(0, request.path)

    ActiveSupport::Cache.expand_cache_key(key)
  end
end
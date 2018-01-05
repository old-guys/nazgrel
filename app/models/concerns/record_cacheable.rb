module RecordCacheable
  extend ActiveSupport::Concern

  included do
    delegate :fetch_multi, to: "self.class"
  end


  private
  module ClassMethods
    def fetch_multi(records: , cache_key: , raw: true)
      _keys = records.map(&cache_key.to_sym)
      _cached_results = Rails.cache.read_multi(*_keys, raw: raw)

      records.inject({}) do |memo, record|
        name = record.send(cache_key)
        memo[name] = _cached_results[name] || (yield record)

        memo
      end
    end
  end
end
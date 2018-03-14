json.partial! 'api/shared/paginator', records: @shopkeepers

json.cache! ['api/open_mobile/shopkeepers/report', @shopkeepers], expires_in: 1.hours do
  json.models do
    Shopkeeper.with_preload_parents(records: @shopkeepers)

    json.cache_collection! @shopkeepers.to_a, key: 'api/open/mobile/shopkeepers/report', expires_in: 2.days do |record|
      json.partial! 'api/open_mobile/shopkeepers/report_show',
        locals: {record: record}
    end
  end
end
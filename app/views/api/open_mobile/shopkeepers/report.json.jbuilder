json.partial! 'api/shared/paginator', records: @shopkeepers

json.models do
  Shopkeeper.with_preload_parents(records: @shopkeepers)

  json.cache_collection! @shopkeepers.to_a, key: 'api/open/mobile/shopkeepers/report', expires_in: 1.hours do |record|
    json.partial! 'api/open_mobile/shopkeepers/report_show',
      locals: {record: record}
  end
end
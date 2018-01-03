json.partial! 'api/shared/paginator', records: @shopkeepers

json.cache! ['api/open_mobile/shopkeepers/report', @shopkeepers] do
  json.models do
    Shopkeeper.with_preload_parents(records: @shopkeepers)

    json.cache_collection! @shopkeepers, key: 'api/open/mobile/shopkeepers/report' do |record|
      json.partial! 'api/open_mobile/shopkeepers/report_show',
        locals: {record: record}
    end
  end
end
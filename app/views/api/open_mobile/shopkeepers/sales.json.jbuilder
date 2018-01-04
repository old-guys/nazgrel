json.partial! 'api/shared/paginator', records: @shopkeepers

json.cache! ['api/open_mobile/shopkeeper', @shopkeepers] do
  json.models do
    json.cache_collection! @shopkeepers, key: 'api/open_mobile/shopkeepers/sales_show' do |record|
      json.partial! 'api/open_mobile/shopkeepers/sales_show',
        locals: {record: record}
    end
  end
end
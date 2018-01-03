json.partial! 'api/shared/paginator', records: @orders
json.cache! ['api/channel/orders/refund', @orders] do
  json.models do
    json.cache_collection! @orders, key: 'api/channel/orders/show' do |record|
      json.partial! 'api/channel/orders/show',
        locals: {record: record}
    end
  end
end
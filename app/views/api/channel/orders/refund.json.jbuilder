json.partial! 'api/shared/paginator', records: @orders
json.cache! ['api/channel/orders/refund', @orders, expires_in: 3.minutes] do
  json.models do
    json.partial! 'api/channel/orders/show', collection: @orders, as: :record
  end
end
json.partial! 'api/shared/paginator', records: @shops

json.cache! ['api/channel/shops/sales', @shops] do
  json.models do
    json.partial! 'api/channel/shops/sales_show', collection: @shops, as: :record
  end
end

json.total_order_amount @channel_user.total_order_amount
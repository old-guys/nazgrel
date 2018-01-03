json.partial! 'api/shared/paginator', records: @shops

json.cache! ['api/channel/shops/sales', @shops] do
  json.models do
    json.cache_collection! @shops, key: proc {|record| ['api/channel/shops/show', record.shopkeeper] } do |record|
      json.partial! 'api/channel/shops/sales_show',
        locals: {record: record}
    end
  end
end

json.total_order_amount @channel_user.total_order_amount
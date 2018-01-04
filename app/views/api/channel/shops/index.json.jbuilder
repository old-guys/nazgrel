json.partial! 'api/shared/paginator', records: @shops

json.cache! ['api/channel/shops', @shops] do
  json.models do
    json.cache_collection! @shops, key: proc {|record| ['api/channel/shops/show', record.shopkeeper] }, expires_in: 30.minutes do |record|
      json.partial! 'api/channel/shops/show',
        locals: {record: record}
    end
  end
end
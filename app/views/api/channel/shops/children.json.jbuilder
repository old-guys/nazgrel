json.id @shop.id
json.name @shop.to_s

json.cache! ['api/channel/shops/children', @shops] do
  json.children do
    json.cache_collection! @shops, key: proc {|record| ['api/channel/shops/show', record.shopkeeper] }, expires_in: 30.minutes do |record|
      json.partial! 'api/channel/shops/show',
        locals: {record: record}
    end
  end
end
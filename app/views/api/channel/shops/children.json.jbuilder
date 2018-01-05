json.id @shop.id
json.name @shop.to_s

json.cache! ['api/channel/shops/children', @shops] do
  json.children do
    json.cache_collection! @shops.to_a, key: proc {|record| ['api/channel/shops/show', [record, record.shopkeeper]] } do |record|
      json.partial! 'api/channel/shops/show',
        locals: {record: record}
    end
  end
end
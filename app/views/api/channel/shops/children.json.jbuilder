json.id @shop.id
json.name @shop.to_s

json.cache! ['api/channel/shops/children', @shops, expires_in: 3.minutes] do
  json.children do
    json.partial! 'api/channel/shops/show', collection: @shops, as: :record
  end
end
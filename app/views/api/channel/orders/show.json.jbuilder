json.id @shop.id
json.name @shop.to_s
json.desc @shop.desc

if @shop.shopkeeper.present?
  json.shopkeeper do
    json.partial! 'api/channel/shopkeepers/show', record: @shop.shopkeeper
  end
end

json.id @shop.id
json.name @shop.to_s
json.desc @shop.desc

json.shopkeeper({})
json.shopkeeper do
  if @shop.shopkeeper.present?
    json.partial! 'api/channel/shopkeepers/show', record: @shop.shopkeeper
  end
end
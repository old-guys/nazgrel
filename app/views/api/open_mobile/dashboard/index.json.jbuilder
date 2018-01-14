json.(@result, *@result.keys)

json.shop({})
if @permit_shop
  json.cache! ['api/open_mobile/dashboard#shop', @permit_shop] do
    json.shop do
      json.id @permit_shop.id
      json.name @permit_shop.to_s
      json.shopkeeper_user_name @permit_shop.shopkeeper.try :user_name
      json.shopkeeper_user_phone @permit_shop.shopkeeper.try :user_phone
    end
  end
end
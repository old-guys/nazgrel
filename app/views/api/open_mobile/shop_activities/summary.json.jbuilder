record = @shop.shopkeeper
_descendant_activation_rate = record.descendant_activation_rate.blank? ? nil : number_to_percentage(record.descendant_activation_rate * 100, precision: 1)

json.cache! ['api/open/mobile/shop_activities/summary', record, @shop.shopkeeper] do
  json.id @shop.id

  json.shop_name record.shop.to_s
  json.shop_img_url record.shop.shop_img_url
  json.shopkeeper_name record.to_s

  json.province record.province
  json.city record.city
  json.descendant_activation_rate _descendant_activation_rate

  json.descendant_count record.descendant_size
end

json.activity_info do
  json.array! @result do |item|
    json.(item, *item.keys)
  end
end
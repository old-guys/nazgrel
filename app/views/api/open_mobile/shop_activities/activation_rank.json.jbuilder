json.cache! ['api/open/mobile/shop_activities/activation_rank', @report_shop_ecns] do
  json.models @report_shop_ecns do |record|
    _descendant_activation_rate = record.descendant_activation_rate.blank? ? nil : number_to_percentage(record.descendant_activation_rate * 100, precision: 1)
    _shop = record.shop
    _shopkeeper = _shop.shopkeeper

    json.shop_id _shop.id
    json.shop_name _shop.to_s
    json.shop_img_url _shop.shop_img_url
    json.shopkeeper_name _shopkeeper.to_s

    json.province _shopkeeper.province
    json.city _shopkeeper.city

    json.descendant_activation_rate _descendant_activation_rate
  end
end
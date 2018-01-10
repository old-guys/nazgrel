record = @shop.shopkeeper

json.cache! ['api/open/mobile/shops/summary', record, @shop.shopkeeper] do
  json.id @shop.id

  json.shop_name record.shop.to_s
  json.shopkeeper_name record.to_s

  json.province record.province
  json.city record.city

  json.user_phone record.user_phone

  json.commission_income_amount record.commission_income_amount
  json.balance_amount record.balance_amount
  json.withdraw_amount record.withdraw_amount

  json.last_three_day_descendant_count record.descendant_entities.where(
    created_at: 3.day.ago.beginning_of_day..Time.now.end_of_day
  ).size
  json.descendant_count record.descendant_size

  json.created_at record.created_at
end
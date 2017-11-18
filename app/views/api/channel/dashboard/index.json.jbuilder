json.shop_count @result[:shop_count]
json.order_count @result[:order_count]
json.commission_amount @result[:commission_amount]

json.today do
  json.shop_count @result[:today][:shop_count]
  json.order_count @result[:today][:order_count]
end

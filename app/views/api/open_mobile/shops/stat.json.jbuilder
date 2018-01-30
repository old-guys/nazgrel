record = @shop.shopkeeper

json.cache! ['api/open/mobile/shops/stat', record, @shop.shopkeeper] do
  json.id @shop.id

  json.descendant_count record.descendant_size
  json.children_count record.children_size

  json.order_number record.order_number
  json.order_amount record.order_amount

  json.all_order_number record.descendant_order_number + record.order_number.to_i
  json.all_order_amount (record.descendant_order_amount.to_f + record.order_amount.to_f).to_s

  json.partial! 'api/open_mobile/shops/fast_add_shop',
    locals: {
      record: record
    }

  json.partial! 'api/open_mobile/shops/top_sales_shop',
    locals: {
      record: record
    }
end
record = @shop.shopkeeper

json.cache! ['api/open/mobile/shops/stat', record, @shop.shopkeeper, expires_in: 10.minutes] do
  json.id record.id

  json.descendant_count record.descendant_size
  json.children_count record.children.size

  json.order_number record.order_number
  json.order_amount record.order_amount

  json.all_order_number record.self_and_descendant_entities.sum(:order_number)
  json.all_order_amount record.self_and_descendant_entities.sum(:order_amount)

  json.partial! 'api/open_mobile/shops/fast_add_shop',
    locals: {
      record: record
    }

  json.partial! 'api/open_mobile/shops/top_sales_shop',
    locals: {
      record: record
    }
end
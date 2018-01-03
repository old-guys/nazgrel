json.cache! ["api/open_mobile/shops/stat/top_sales_shop", record, expires_in: 30.minutes] do
  json.top_sales_shop({})
  json.top_sales_shop do
    item = Shopkeeper.order_amount_rank(
      records: record.descendant_entities,
      dates: 30.days.ago.to_date..Date.today,
      limit: 1
    ).pop

    if item.present?
      _shopkeeper = Shopkeeper.preload(:shop).find_by(shop_id: item.shop_id)

      json.shop_id _shopkeeper.shop_id
      json.shop_name _shopkeeper.shop.to_s
      json.shopkeeper_name _shopkeeper.to_s
      json.city _shopkeeper.city
      json.amount item.amount
    end
  end
end
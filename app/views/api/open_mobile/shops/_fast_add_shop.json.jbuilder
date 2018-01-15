  json.cache! ["api/open_mobile/shops/stat/fast_add_shop", record, expires_in: 30.minutes] do
    json.fast_add_shop({})
    json.fast_add_shop do
      item = Shopkeeper.children_rank(
        records: record.descendant_entities,
        dates: 30.days.ago.beginning_of_day..Time.now.end_of_day,
        limit: 1
      ).pop

      if item.present?
        _shopkeeper = Shopkeeper.preload(:shop).find_by(user_id: item.user_id)
        _total_count = record.descendant_entities.where(
          created_at: 30.days.ago.beginning_of_day..Time.now.end_of_day
        ).count

        json.shop_id _shopkeeper.shop_id
        json.shop_name _shopkeeper.shop.to_s
        json.shopkeeper_name _shopkeeper.to_s
        json.city _shopkeeper.city
        json.count item.count
        json.proportion number_to_percentage((item.count / _total_count.to_f) * 100, precision: 1)
      end
    end
  end
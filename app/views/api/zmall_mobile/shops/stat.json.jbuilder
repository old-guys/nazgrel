json.id @shop.id

json.models do
  json.cache_collection! @report_shop_activities.to_a, key: 'api/zmall/mobile/shops/stat' do |report_shop_activity|
    json.report_month report_shop_activity.report_date.strftime("%Y-%m")
    json.(report_shop_activity,
      :month_shopkeeper_order_number,
      :month_shopkeeper_order_amount,
      :month_sale_order_number,
      :month_sale_order_amount,
      :month_commission_income_amount,
      :month_balance_amount,
      :month_income_coin,
      :month_use_coin,
      :month_balance_coin
    )
  end
end
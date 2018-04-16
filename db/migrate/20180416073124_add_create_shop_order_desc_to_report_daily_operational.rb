class AddCreateShopOrderDescToReportDailyOperational < ActiveRecord::Migration[5.2]
  def change
    add_column :report_daily_operationals, :create_shop_order_total_price,
      :decimal, precision: 11, scale: 3, after: :shopkeeper_order_total_price_rate, comment: "开店订单总额"
    add_column :report_daily_operationals, :create_shop_order_total_price_rate,
      :float, after: :create_shop_order_total_price, comment: "开店订单总额占比"
  end
end
class AddOrderDescToReportDailyOperational < ActiveRecord::Migration[5.2]
  def change
    add_column :report_daily_operationals, :sale_order_total_price, :decimal, precision: 11, scale: 3, comment: "销售订单总额"
    add_column :report_daily_operationals, :sale_order_total_price_rate, :float, comment: "销售订单总额占比"
    add_column :report_daily_operationals, :shopkeeper_order_total_price, :decimal, precision: 11, scale: 3, comment: "自购订单总额"
    add_column :report_daily_operationals, :shopkeeper_order_total_price_rate, :float, comment: "自购订单总额占比"
  end
end
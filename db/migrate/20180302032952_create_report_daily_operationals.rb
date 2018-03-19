class CreateReportDailyOperationals < ActiveRecord::Migration[5.2]
  def change
    create_table :report_daily_operationals, comment: "每日运营报表" do |t|
      t.date :report_date, comment: "报表日期"

      t.integer :total_shopkeeper_count, comment: "累计店主数"
      t.integer :shopkeeper_count, comment: "店主数"

      t.integer :activation_shopkeeper_count, comment: "活跃店主数"
      t.float :activation_shopkeeper_rate, comment: "活跃店主比例"

      t.integer :view_count, comment: "浏览量"
      t.integer :viewer_count, comment: "访客数"
      t.integer :shared_count, comment: "分享数"

      t.decimal :order_total_price, precision: 11, scale: 3, comment: "订单总额"
      t.integer :order_count, comment: "订单数"
      t.decimal :order_pay_price, precision: 11, scale: 3, comment: "支付金额"

      t.float :order_conversion_rate, comment: "转化率（订单数/浏览量）"
      t.decimal :order_total_price_avg, precision: 11, scale: 3, comment: "平均每单金额"

      t.decimal :commission_income_amount, precision: 11, scale: 3, comment: "佣金"

      t.decimal :activity_ticket_amount, precision: 11, scale: 3, comment: "现金券"
      t.decimal :product_cost, precision: 11, scale: 3, comment: "成本"

      t.timestamps
    end

    add_index :report_daily_operationals, :report_date
  end
end
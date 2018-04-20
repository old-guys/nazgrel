class AddOrderNumberToReportDailyOperationalShopGradeSummary < ActiveRecord::Migration[5.2]
  def change
    add_column :report_daily_operational_shop_grade_summaries, :grade_gold_sale_order_number, :integer, before: :grade_gold_sale_order_amount, comment: "白金店主销售订单数"
    add_column :report_daily_operational_shop_grade_summaries, :grade_gold_shopkeeper_order_number, :integer, before: :grade_gold_shopkeeper_order_amount, comment: "白金店主自购订单数"
    add_column :report_daily_operational_shop_grade_summaries, :grade_platinum_sale_order_number, :integer, before: :grade_platinum_sale_order_amount, comment: "黄金店主销售订单数"
    add_column :report_daily_operational_shop_grade_summaries, :grade_platinum_shopkeeper_order_number, :integer, before: :grade_platinum_shopkeeper_order_amount, comment: "黄金店主自购订单数"
    add_column :report_daily_operational_shop_grade_summaries, :grade_trainee_sale_order_number, :integer, before: :grade_trainee_sale_order_amount, comment: "体验店主销售订单数"
    add_column :report_daily_operational_shop_grade_summaries, :grade_trainee_shopkeeper_order_number, :integer, before: :grade_trainee_shopkeeper_order_amount, comment: "体验店主自购订单数"
  end
end
class AddDescendantOrderAmountToReportCumulativeShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_cumulative_shop_activities, :day_0_descendant_order_amount, :integer, default: 0, after: :day_60_order_amount, comment: "当天下级订单金额"
    add_column :report_cumulative_shop_activities, :day_3_descendant_order_amount, :integer, default: 0, after: :day_0_descendant_order_amount, comment: "3天下级订单金额"
    add_column :report_cumulative_shop_activities, :day_7_descendant_order_amount, :integer, default: 0, after: :day_3_descendant_order_amount, comment: "7天下级订单金额"
    add_column :report_cumulative_shop_activities, :day_15_descendant_order_amount, :integer, default: 0, after: :day_7_descendant_order_amount, comment: "15天下级订单金额"
    add_column :report_cumulative_shop_activities, :day_30_descendant_order_amount, :integer, default: 0, after: :day_15_descendant_order_amount, comment: "30天下级订单金额"
    add_column :report_cumulative_shop_activities, :day_60_descendant_order_amount, :integer, default: 0, after: :day_30_descendant_order_amount, comment: "60天下级订单金额"
    add_column :report_cumulative_shop_activities, :total_descendant_order_amount, :integer, default: 0, after: :day_60_descendant_order_amount, comment: "总下级订单金额"
  end
end
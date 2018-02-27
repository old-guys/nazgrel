class AddDescendantOrderAmountToReportShopActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :report_shop_activities, :descendant_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :total_sale_order_amount, comment: "下级订单金额"
    add_column :report_shop_activities, :stage_1_descendant_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :descendant_order_amount, comment: "00:00-9:00 下级订单金额"
    add_column :report_shop_activities, :stage_2_descendant_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_1_descendant_order_amount, comment: "09:00-18:00 下级订单金额"
    add_column :report_shop_activities, :stage_3_descendant_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_2_descendant_order_amount, comment: "18:00-24:00 下级订单金额"
    add_column :report_shop_activities, :week_descendant_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_3_descendant_order_amount, comment: "本月下级订单金额"
    add_column :report_shop_activities, :month_descendant_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :week_descendant_order_amount, comment: "本月下级订单金额"
    add_column :report_shop_activities, :year_descendant_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :month_descendant_order_amount, comment: "本年下级订单金额"
    add_column :report_shop_activities, :total_descendant_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :year_descendant_order_amount, comment: "总下级订单金额"
  end
end
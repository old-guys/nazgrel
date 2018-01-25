class AddWeekStatFieldToReportChannelShopActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :report_channel_shop_activities, :week_shared_count, :integer, default: 0, before: :month_shared_count, comment: "本周分享次数"
    add_column :report_channel_shop_activities, :week_view_count, :integer, default: 0, before: :month_view_count, comment: "本周浏览次数"
    add_column :report_channel_shop_activities, :week_viewer_count, :integer, default: 0, before: :month_viewer_count, comment: "本周访客次数"
    add_column :report_channel_shop_activities, :week_order_number, :integer, default: 0, before: :month_order_number, comment: "本周订单数"
    add_column :report_channel_shop_activities, :week_shopkeeper_order_number, :integer, default: 0, before: :month_shopkeeper_order_number, comment: "本周自购订单数"
    add_column :report_channel_shop_activities, :week_sale_order_number, :integer, default: 0, before: :month_sale_order_number, comment: "本周销售订单数"
    add_column :report_channel_shop_activities, :week_order_amount, :decimal, precision: 11, scale: 3, default: 0, before: :month_order_amount, comment: "本周订单金额"
    add_column :report_channel_shop_activities, :week_shopkeeper_order_amount, :decimal, precision: 11, scale: 3, default: 0, before: :month_shopkeeper_order_amount, comment: "本周自购订单金额"
    add_column :report_channel_shop_activities, :week_sale_order_amount, :decimal, precision: 11, scale: 3, default: 0, before: :month_sale_order_amount, comment: "本周销售订单金额"
    add_column :report_channel_shop_activities, :week_children_grade_platinum_count, :integer, default: 0, before: :month_children_grade_platinum_count, comment: "本周邀请白金店主数"
    add_column :report_channel_shop_activities, :week_children_grade_gold_count, :integer, default: 0, before: :month_children_grade_gold_count, comment: "本周邀请黄金店主数"
    add_column :report_channel_shop_activities, :week_ecn_grade_platinum_count, :integer, default: 0, before: :month_ecn_grade_platinum_count, comment: "本周ECN白金店主数"
    add_column :report_channel_shop_activities, :week_ecn_grade_gold_count, :integer, default: 0, before: :month_ecn_grade_gold_count, comment: "本周ECN黄金店主数"
  end
end
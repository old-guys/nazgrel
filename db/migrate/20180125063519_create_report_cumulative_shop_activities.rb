class CreateReportCumulativeShopActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :report_cumulative_shop_activities, comment: "累计店主行为数据" do |t|
      t.bigint :shop_id
      t.date :report_date, comment: "报表日期"

      t.integer :day_0_shared_count, default: 0, comment: "当天分享次数"
      t.integer :day_3_shared_count, default: 0, comment: "3天分享次数"
      t.integer :day_7_shared_count, default: 0, comment: "7天分享次数"
      t.integer :day_15_shared_count, default: 0, comment: "15天分享次数"
      t.integer :day_30_shared_count, default: 0, comment: "30天分享次数"
      t.integer :day_60_shared_count, default: 0, comment: "60天分享次数"

      t.integer :day_0_view_count, default: 0, comment: "当天浏览次数"
      t.integer :day_3_view_count, default: 0, comment: "3天浏览次数"
      t.integer :day_7_view_count, default: 0, comment: "7天浏览次数"
      t.integer :day_15_view_count, default: 0, comment: "15天浏览次数"
      t.integer :day_30_view_count, default: 0, comment: "30天浏览次数"
      t.integer :day_60_view_count, default: 0, comment: "60天浏览次数"

      t.integer :day_0_viewer_count, default: 0, comment: "当天访客次数"
      t.integer :day_3_viewer_count, default: 0, comment: "3天访客次数"
      t.integer :day_7_viewer_count, default: 0, comment: "7天访客次数"
      t.integer :day_15_viewer_count, default: 0, comment: "15天访客次数"
      t.integer :day_30_viewer_count, default: 0, comment: "30天访客次数"
      t.integer :day_60_viewer_count, default: 0, comment: "60天访客次数"

      t.integer :day_0_order_number, default: 0, comment: "当天订单数"
      t.integer :day_3_order_number, default: 0, comment: "3天订单数"
      t.integer :day_7_order_number, default: 0, comment: "7天订单数"
      t.integer :day_15_order_number, default: 0, comment: "15天订单数"
      t.integer :day_30_order_number, default: 0, comment: "30天订单数"
      t.integer :day_60_order_number, default: 0, comment: "60天订单数"

      t.integer :day_0_shopkeeper_order_number, default: 0, comment: "当天自购订单数"
      t.integer :day_3_shopkeeper_order_number, default: 0, comment: "3天自购订单数"
      t.integer :day_7_shopkeeper_order_number, default: 0, comment: "7天自购订单数"
      t.integer :day_15_shopkeeper_order_number, default: 0, comment: "15天自购订单数"
      t.integer :day_30_shopkeeper_order_number, default: 0, comment: "30天自购订单数"
      t.integer :day_60_shopkeeper_order_number, default: 0, comment: "60天自购订单数"

      t.integer :day_0_sale_order_number, default: 0, comment: "当天销售订单数"
      t.integer :day_3_sale_order_number, default: 0, comment: "3天销售订单数"
      t.integer :day_7_sale_order_number, default: 0, comment: "7天销售订单数"
      t.integer :day_15_sale_order_number, default: 0, comment: "15天销售订单数"
      t.integer :day_30_sale_order_number, default: 0, comment: "30天销售订单数"
      t.integer :day_60_sale_order_number, default: 0, comment: "60天销售订单数"

      t.decimal :day_0_order_amount, precision: 11, scale: 3, default: 0, comment: "当天订单金额"
      t.decimal :day_3_order_amount, precision: 11, scale: 3, default: 0, comment: "3天订单金额"
      t.decimal :day_7_order_amount, precision: 11, scale: 3, default: 0, comment: "7天订单金额"
      t.decimal :day_15_order_amount, precision: 11, scale: 3, default: 0, comment: "15天订单金额"
      t.decimal :day_30_order_amount, precision: 11, scale: 3, default: 0, comment: "30天订单金额"
      t.decimal :day_60_order_amount, precision: 11, scale: 3, default: 0, comment: "60天订单金额"

      t.decimal :day_0_shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "当天自购订单金额"
      t.decimal :day_3_shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "3天自购订单金额"
      t.decimal :day_7_shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "7天自购订单金额"
      t.decimal :day_15_shopkeeper_order_amount, precision: 11, scale: 3, default: 00, comment: "15天自购订单金额"
      t.decimal :day_30_shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "30天自购订单金额"
      t.decimal :day_60_shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "60天自购订单金额"

      t.decimal :day_0_sale_order_amount, precision: 11, scale: 3, default: 0, comment: "当天销售订单金额"
      t.decimal :day_3_sale_order_amount, precision: 11, scale: 3, default: 0, comment: "3天销售订单金额"
      t.decimal :day_7_sale_order_amount, precision: 11, scale: 3, default: 0, comment: "7天销售订单金额"
      t.decimal :day_15_sale_order_amount, precision: 11, scale: 3, default: 00, comment: "15天销售订单金额"
      t.decimal :day_30_sale_order_amount, precision: 11, scale: 3, default: 0, comment: "30天销售订单金额"
      t.decimal :day_60_sale_order_amount, precision: 11, scale: 3, default: 0, comment: "60天销售订单金额"

      t.integer :day_0_children_grade_platinum_count, default: 0, comment: "当天邀请白金店主数"
      t.integer :day_3_children_grade_platinum_count, default: 0, comment: "3天邀请白金店主数"
      t.integer :day_7_children_grade_platinum_count, default: 0, comment: "7天邀请白金店主数"
      t.integer :day_15_children_grade_platinum_count, default: 0, comment: "15天邀请白金店主数"
      t.integer :day_30_children_grade_platinum_count, default: 0, comment: "30天邀请白金店主数"
      t.integer :day_60_children_grade_platinum_count, default: 0, comment: "60天邀请白金店主数"

      t.integer :day_0_children_grade_gold_count, default: 0, comment: "当天邀请黄金店主数"
      t.integer :day_3_children_grade_gold_count, default: 0, comment: "3天邀请黄金店主数"
      t.integer :day_7_children_grade_gold_count, default: 0, comment: "7天邀请黄金店主数"
      t.integer :day_15_children_grade_gold_count, default: 0, comment: "15天邀请黄金店主数"
      t.integer :day_30_children_grade_gold_count, default: 0, comment: "30天邀请黄金店主数"
      t.integer :day_60_children_grade_gold_count, default: 0, comment: "60天邀请黄金店主数"

      t.integer :day_0_ecn_grade_platinum_count, default: 0, comment: "当天ECN白金店主数"
      t.integer :day_3_ecn_grade_platinum_count, default: 0, comment: "3天ECN白金店主数"
      t.integer :day_7_ecn_grade_platinum_count, default: 0, comment: "7天ECN白金店主数"
      t.integer :day_15_ecn_grade_platinum_count, default: 0, comment: "15天ECN白金店主数"
      t.integer :day_30_ecn_grade_platinum_count, default: 0, comment: "30天ECN白金店主数"
      t.integer :day_60_ecn_grade_platinum_count, default: 0, comment: "60天ECN白金店主数"

      t.integer :day_0_ecn_grade_gold_count, default: 0, comment: "当天ECN黄金店主数"
      t.integer :day_3_ecn_grade_gold_count, default: 0, comment: "3天ECN黄金店主数数"
      t.integer :day_7_ecn_grade_gold_count, default: 0, comment: "7天ECN黄金店主数"
      t.integer :day_15_ecn_grade_gold_count, default: 0, comment: "15天ECN黄金店主数"
      t.integer :day_30_ecn_grade_gold_count, default: 0, comment: "30天ECN黄金店主数"
      t.integer :day_60_ecn_grade_gold_count, default: 0, comment: "60天ECN黄金店主数"

      t.timestamps
    end

    add_index :report_cumulative_shop_activities, :report_date
    add_index :report_cumulative_shop_activities, :shop_id
  end
end
class CreateReportShopActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :report_shop_activities, comment: "店主行为数据" do |t|
      t.date :report_date, comment: "报表日期"
      t.bigint :shop_id, comment: "店铺ID"

      t.integer :shared_count, default: 0, comment: "分享次数"
      t.integer :stage_1_shared_count, default: 0, comment: "00:00-9:00 分享次数"
      t.integer :stage_2_shared_count, default: 0, comment: "09:00-18:00 分享次数"
      t.integer :stage_3_shared_count, default: 0, comment: "18:00-24:00 分享次数"
      t.integer :month_shared_count, default: 0, comment: "本月分享次数"
      t.integer :year_shared_count, default: 0, comment: "本年分享次数"

      t.integer :view_count, default: 0, comment: "浏览次数"
      t.integer :stage_1_view_count, default: 0, comment: "00:00-9:00 浏览次数"
      t.integer :stage_2_view_count, default: 0, comment: "09:00-18:00 浏览次数"
      t.integer :stage_3_view_count, default: 0, comment: "18:00-24:00 浏览次数"
      t.integer :month_view_count, default: 0, comment: "本月浏览次数"
      t.integer :year_view_count, default: 0, comment: "本年浏览次数"

      t.integer :order_number, default: 0, comment: "订单数"
      t.integer :stage_1_order_number, default: 0, comment: "00:00-9:00 订单数"
      t.integer :stage_2_order_number, default: 0, comment: "09:00-18:00 订单数"
      t.integer :stage_3_order_number, default: 0, comment: "18:00-24:00 订单数"
      t.integer :month_order_number, default: 0, comment: "本月订单数"
      t.integer :year_order_number, default: 0, comment: "本年订单数"

      t.integer :shopkeeper_order_number, default: 0, comment: "自购订单数"
      t.integer :stage_1_shopkeeper_order_number, default: 0, comment: "00:00-9:00 自购订单数"
      t.integer :stage_2_shopkeeper_order_number, default: 0, comment: "09:00-18:00 自购订单数"
      t.integer :stage_3_shopkeeper_order_number, default: 0, comment: "18:00-24:00 自购订单数"
      t.integer :month_shopkeeper_order_number, default: 0, comment: "本月自购订单数"
      t.integer :year_shopkeeper_order_number, default: 0, comment: "本年自购订单数"

      t.integer :sale_order_number, default: 0, comment: "销售订单数"
      t.integer :stage_1_sale_order_number, default: 0, comment: "00:00-9:00 销售订单数"
      t.integer :stage_2_sale_order_number, default: 0, comment: "09:00-18:00 销售订单数"
      t.integer :stage_3_sale_order_number, default: 0, comment: "18:00-24:00 销售订单数"
      t.integer :month_sale_order_number, default: 0, comment: "本月销售订单数"
      t.integer :year_sale_order_number, default: 0, comment: "本年销售订单数"

      t.decimal :order_amount, precision: 11, scale: 3, default: 0, comment: "订单金额"
      t.decimal :stage_1_order_amount, precision: 11, scale: 3, default: 0, comment: "00:00-9:00 订单金额"
      t.decimal :stage_2_order_amount, precision: 11, scale: 3, default: 0, comment: "09:00-18:00 订单金额"
      t.decimal :stage_3_order_amount, precision: 11, scale: 3, default: 0, comment: "18:00-24:00 订单金额"
      t.decimal :month_order_amount, precision: 11, scale: 3, default: 0, comment: "本月订单金额"
      t.decimal :year_order_amount, precision: 11, scale: 3, default: 0, comment: "本年订单金额"

      t.decimal :shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "自购订单金额"
      t.decimal :stage_1_shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "00:00-9:00 自购订单金额"
      t.decimal :stage_2_shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "09:00-18:00 自购订单金额"
      t.decimal :stage_3_shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "18:00-24:00 自购订单金额"
      t.decimal :month_shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "本月自购订单金额"
      t.decimal :year_shopkeeper_order_amount, precision: 11, scale: 3, default: 0, comment: "本年自购订单金额"

      t.decimal :sale_order_amount, precision: 11, scale: 3, default: 0, comment: "销售订单金额"
      t.decimal :stage_1_sale_order_amount, precision: 11, scale: 3, default: 0, comment: "00:00-9:00 销售订单金额"
      t.decimal :stage_2_sale_order_amount, precision: 11, scale: 3, default: 0, comment: "09:00-18:00 销售订单金额"
      t.decimal :stage_3_sale_order_amount, precision: 11, scale: 3, default: 0, comment: "18:00-24:00 销售订单金额"
      t.decimal :month_sale_order_amount, precision: 11, scale: 3, default: 0, comment: "销售订单金额"
      t.decimal :year_sale_order_amount, precision: 11, scale: 3, default: 0, comment: "销售订单金额"

      t.integer :children_grade_platinum_count, default: 0, comment: "邀请白金店主数"
      t.integer :stage_1_children_grade_platinum_count, default: 0, comment: "00:00-9:00 邀请白金店主数"
      t.integer :stage_2_children_grade_platinum_count, default: 0, comment: "09:00-18:00 邀请白金店主数"
      t.integer :stage_3_children_grade_platinum_count, default: 0, comment: "18:00-24:00 邀请白金店主数"
      t.integer :month_children_grade_platinum_count, default: 0, comment: "本月邀请白金店主数"
      t.integer :year_children_grade_platinum_count, default: 0, comment: "本年邀请白金店主数"

      t.integer :children_grade_gold_count, default: 0, comment: "邀请黄金店主数"
      t.integer :stage_1_children_grade_gold_count, default: 0, comment: "00:00-9:00 邀请黄金店主数"
      t.integer :stage_2_children_grade_gold_count, default: 0, comment: "09:00-18:00 邀请黄金店主数"
      t.integer :stage_3_children_grade_gold_count, default: 0, comment: "18:00-24:00 邀请黄金店主数"
      t.integer :month_children_grade_gold_count, default: 0, comment: "本月邀请黄金店主数"
      t.integer :year_children_grade_gold_count, default: 0, comment: "本年邀请黄金店主数"

      t.integer :ecn_grade_platinum_count, default: 0, comment: "ECN白金店主数"
      t.integer :stage_1_ecn_grade_platinum_count, default: 0, comment: "00:00-9:00 ECN白金店主数"
      t.integer :stage_2_ecn_grade_platinum_count, default: 0, comment: "09:00-18:00 ECN白金店主数"
      t.integer :stage_3_ecn_grade_platinum_count, default: 0, comment: "18:00-24:00 ECN白金店主数"
      t.integer :month_ecn_grade_platinum_count, default: 0, comment: "本月ECN白金店主数"
      t.integer :year_ecn_grade_platinum_count, default: 0, comment: "本年ECN白金店主数"

      t.integer :ecn_grade_gold_count, default: 0, comment: "ECN黄金店主数"
      t.integer :stage_1_ecn_grade_gold_count, default: 0, comment: "00:00-9:00 ECN黄金店主数"
      t.integer :stage_2_ecn_grade_gold_count, default: 0, comment: "09:00-18:00 ECN黄金店主数"
      t.integer :stage_3_ecn_grade_gold_count, default: 0, comment: "18:00-24:00 ECN黄金店主数"
      t.integer :month_ecn_grade_gold_count, default: 0, comment: "本月ECN黄金店主数"
      t.integer :year_ecn_grade_gold_count, default: 0, comment: "本年ECN黄金店主数"

      t.timestamps
    end
    add_index :report_shop_activities, :report_date
    add_index :report_shop_activities, :shop_id
  end
end
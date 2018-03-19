class AddTotalStatFieldToReportCityShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_city_shop_activities, :total_shared_count, :integer, default: 0, after: :year_shared_count, comment: "总分享次数"
    add_column :report_city_shop_activities, :total_view_count, :integer, default: 0, after: :year_view_count, comment: "总浏览次数"
    add_column :report_city_shop_activities, :total_viewer_count, :integer, default: 0, after: :year_viewer_count, comment: "总访客次数"
    add_column :report_city_shop_activities, :total_order_number, :integer, default: 0, after: :year_order_number, comment: "总订单数"
    add_column :report_city_shop_activities, :total_shopkeeper_order_number, :integer, default: 0, after: :year_shopkeeper_order_number, comment: "总自购订单数"
    add_column :report_city_shop_activities, :total_sale_order_number, :integer, default: 0, after: :year_sale_order_number, comment: "总销售订单数"
    add_column :report_city_shop_activities, :total_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :year_order_amount, comment: "总订单金额"
    add_column :report_city_shop_activities, :total_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :year_order_amount, comment: "总店铺佣金"
    add_column :report_city_shop_activities, :total_shopkeeper_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :year_shopkeeper_order_amount, comment: "总自购订单金额"
    add_column :report_city_shop_activities, :total_sale_order_amount, :decimal, precision: 11, scale: 3, default: 0, after: :year_sale_order_amount, comment: "总店主订单金额"
    add_column :report_city_shop_activities, :total_children_grade_platinum_count, :integer, default: 0, after: :year_children_grade_platinum_count, comment: "总邀请白金店主数"
    add_column :report_city_shop_activities, :total_children_grade_gold_count, :integer, default: 0, after: :year_children_grade_gold_count, comment: "总邀请黄金店主数"
    add_column :report_city_shop_activities, :total_ecn_grade_platinum_count, :integer, default: 0, after: :year_ecn_grade_platinum_count, comment: "总ECN白金店主数"
    add_column :report_city_shop_activities, :total_ecn_grade_gold_count, :integer, default: 0, after: :year_ecn_grade_gold_count, comment: "总ECN黄金店主数"
  end
end
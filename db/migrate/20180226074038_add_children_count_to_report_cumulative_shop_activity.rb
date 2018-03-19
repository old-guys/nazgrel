class AddChildrenCountToReportCumulativeShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_cumulative_shop_activities, :day_0_children_count, :integer, default: 0, after: :total_children_grade_gold_count, comment: "当天邀请店主数"
    add_column :report_cumulative_shop_activities, :day_3_children_count, :integer, default: 0, after: :day_0_children_count, comment: "3天邀请店主数"
    add_column :report_cumulative_shop_activities, :day_7_children_count, :integer, default: 0, after: :day_3_children_count, comment: "7天邀请店主数"
    add_column :report_cumulative_shop_activities, :day_15_children_count, :integer, default: 0, after: :day_7_children_count, comment: "15天邀请店主数"
    add_column :report_cumulative_shop_activities, :day_30_children_count, :integer, default: 0, after: :day_15_children_count, comment: "30天邀请店主数"
    add_column :report_cumulative_shop_activities, :day_60_children_count, :integer, default: 0, after: :day_30_children_count, comment: "60天邀请店主数"
    add_column :report_cumulative_shop_activities, :total_children_count, :integer, default: 0, after: :day_60_children_count, comment: "总邀请店主数"
  end
end
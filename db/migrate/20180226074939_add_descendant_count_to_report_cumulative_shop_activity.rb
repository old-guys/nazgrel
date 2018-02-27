class AddDescendantCountToReportCumulativeShopActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :report_cumulative_shop_activities, :day_0_descendant_count, :integer, default: 0, after: :total_children_grade_gold_count, comment: "当天下级店主数"
    add_column :report_cumulative_shop_activities, :day_3_descendant_count, :integer, default: 0, after: :day_0_descendant_count, comment: "3天下级店主数"
    add_column :report_cumulative_shop_activities, :day_7_descendant_count, :integer, default: 0, after: :day_3_descendant_count, comment: "7天下级店主数"
    add_column :report_cumulative_shop_activities, :day_15_descendant_count, :integer, default: 0, after: :day_7_descendant_count, comment: "15天下级店主数"
    add_column :report_cumulative_shop_activities, :day_30_descendant_count, :integer, default: 0, after: :day_15_descendant_count, comment: "30天下级店主数"
    add_column :report_cumulative_shop_activities, :day_60_descendant_count, :integer, default: 0, after: :day_30_descendant_count, comment: "60天下级店主数"
    add_column :report_cumulative_shop_activities, :total_descendant_count, :integer, default: 0, after: :day_60_descendant_count, comment: "总下级店主数"
  end
end
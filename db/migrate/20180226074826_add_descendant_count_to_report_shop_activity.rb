class AddDescendantCountToReportShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_shop_activities, :descendant_count, :integer, default: 0, after: :total_children_grade_gold_count, comment: "下级店主数"
    add_column :report_shop_activities, :stage_1_descendant_count, :integer, default: 0, after: :descendant_count, comment: "00:00-9:00 下级店主数"
    add_column :report_shop_activities, :stage_2_descendant_count, :integer, default: 0, after: :stage_1_descendant_count, comment: "09:00-18:00 下级店主数"
    add_column :report_shop_activities, :stage_3_descendant_count, :integer, default: 0, after: :stage_2_descendant_count, comment: "18:00-24:00 下级店主数"
    add_column :report_shop_activities, :week_descendant_count, :integer, default: 0, after: :stage_3_descendant_count, comment: "本月下级店主数"
    add_column :report_shop_activities, :month_descendant_count, :integer, default: 0, after: :week_descendant_count, comment: "本月下级店主数"
    add_column :report_shop_activities, :year_descendant_count, :integer, default: 0, after: :month_descendant_count, comment: "本年下级店主数"
    add_column :report_shop_activities, :total_descendant_count, :integer, default: 0, after: :year_descendant_count, comment: "总下级店主数"
  end
end
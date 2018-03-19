class RemoveChildrenGradeGoldCountFromReportCityShopActivity < ActiveRecord::Migration[5.2]
  def change
    remove_column :report_city_shop_activities, :children_grade_gold_count, :integer, default: 0, comment: "邀请黄金店主数"
    remove_column :report_city_shop_activities, :stage_1_children_grade_gold_count, :integer, default: 0, comment: "00:00-9:00 邀请黄金店主数"
    remove_column :report_city_shop_activities, :stage_2_children_grade_gold_count, :integer, default: 0, comment: "09:00-18:00 邀请黄金店主数"
    remove_column :report_city_shop_activities, :stage_3_children_grade_gold_count, :integer, default: 0, comment: "18:00-24:00 邀请黄金店主数"
    remove_column :report_city_shop_activities, :week_children_grade_gold_count, :integer, default: 0, comment: "本周邀请黄金店主数"
    remove_column :report_city_shop_activities, :month_children_grade_gold_count, :integer, default: 0, comment: "本月邀请黄金店主数"
    remove_column :report_city_shop_activities, :year_children_grade_gold_count, :integer, default: 0, comment: "本年邀请黄金店主数"
    remove_column :report_city_shop_activities, :total_children_grade_gold_count, :integer, default: 0, comment: "总邀请黄金店主数"
  end
end
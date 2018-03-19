class AddChildrenCountToReportShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_shop_activities, :children_count, :integer, default: 0, after: :total_children_grade_gold_count, comment: "邀请店主数"
    add_column :report_shop_activities, :stage_1_children_count, :integer, default: 0, after: :children_count, comment: "00:00-9:00 邀请店主数"
    add_column :report_shop_activities, :stage_2_children_count, :integer, default: 0, after: :stage_1_children_count, comment: "09:00-18:00 邀请店主数"
    add_column :report_shop_activities, :stage_3_children_count, :integer, default: 0, after: :stage_2_children_count, comment: "18:00-24:00 邀请店主数"
    add_column :report_shop_activities, :week_children_count, :integer, default: 0, after: :stage_3_children_count, comment: "本月邀请店主数"
    add_column :report_shop_activities, :month_children_count, :integer, default: 0, after: :week_children_count, comment: "本月邀请店主数"
    add_column :report_shop_activities, :year_children_count, :integer, default: 0, after: :month_children_count, comment: "本年邀请店主数"
    add_column :report_shop_activities, :total_children_count, :integer, default: 0, after: :year_children_count, comment: "总邀请店主数"
  end
end
class AddViewerDescToReportShopActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :report_shop_activities, :viewer_count, :integer, default: 0, comment: "访客数"
    add_column :report_shop_activities, :stage_1_viewer_count, :integer, default: 0, comment: "00:00-9:00 访客数"
    add_column :report_shop_activities, :stage_2_viewer_count, :integer, default: 0, comment: "09:00-18:00 访客数"
    add_column :report_shop_activities, :stage_3_viewer_count, :integer, default: 0, comment: "18:00-24:00 访客数"
    add_column :report_shop_activities, :month_viewer_count, :integer, default: 0, comment: "本月访客数"
    add_column :report_shop_activities, :year_viewer_count, :integer, default: 0, comment: "本年访客数"
  end
end
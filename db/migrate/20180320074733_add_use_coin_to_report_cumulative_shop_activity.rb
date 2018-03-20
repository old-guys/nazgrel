class AddUseCoinToReportCumulativeShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_cumulative_shop_activities, :day_0_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :total_income_coin, comment: "当天使用芝蚂币"
    add_column :report_cumulative_shop_activities, :day_3_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_0_use_coin, comment: "3天使用芝蚂币"
    add_column :report_cumulative_shop_activities, :day_7_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_3_use_coin, comment: "7天使用芝蚂币"
    add_column :report_cumulative_shop_activities, :day_15_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_7_use_coin, comment: "15天使用芝蚂币"
    add_column :report_cumulative_shop_activities, :day_30_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_15_use_coin, comment: "30天使用芝蚂币"
    add_column :report_cumulative_shop_activities, :day_60_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_30_use_coin, comment: "60天使用芝蚂币"
    add_column :report_cumulative_shop_activities, :total_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_60_use_coin, comment: "总使用芝蚂币"
  end
end
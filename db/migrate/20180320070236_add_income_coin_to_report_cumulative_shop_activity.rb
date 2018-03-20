class AddIncomeCoinToReportCumulativeShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_cumulative_shop_activities, :day_0_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :total_withdraw_amount, comment: "当天收入芝蚂币"
    add_column :report_cumulative_shop_activities, :day_3_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_0_income_coin, comment: "3天收入芝蚂币"
    add_column :report_cumulative_shop_activities, :day_7_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_3_income_coin, comment: "7天收入芝蚂币"
    add_column :report_cumulative_shop_activities, :day_15_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_7_income_coin, comment: "15天收入芝蚂币"
    add_column :report_cumulative_shop_activities, :day_30_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_15_income_coin, comment: "30天收入芝蚂币"
    add_column :report_cumulative_shop_activities, :day_60_income_coin, :decimal, precision: 11, scale: 3, default: 0, comment: "60天收入芝蚂币"
    add_column :report_cumulative_shop_activities, :total_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :day_60_income_coin, comment: "总收入芝蚂币"
  end
end
class AddIncomeCoinToReportShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_shop_activities, :income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :total_withdraw_amount, comment: "收入芝蚂币"
    add_column :report_shop_activities, :stage_1_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :income_coin, comment: "00:00-9:00 收入芝蚂币"
    add_column :report_shop_activities, :stage_2_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :stage_1_income_coin, comment: "09:00-18:00 收入芝蚂币"
    add_column :report_shop_activities, :stage_3_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :stage_2_income_coin, comment: "18:00-24:00 收入芝蚂币"
    add_column :report_shop_activities, :week_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :stage_3_income_coin, comment: "本月收入芝蚂币"
    add_column :report_shop_activities, :month_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :week_income_coin, comment: "本周收入芝蚂币"
    add_column :report_shop_activities, :year_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :month_income_coin, comment: "本年收入芝蚂币"
    add_column :report_shop_activities, :total_income_coin, :decimal, precision: 11, scale: 3, default: 0, after: :year_income_coin, comment: "总收入芝蚂币"
  end
end
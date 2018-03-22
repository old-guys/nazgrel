class AddBalanceAmountToReportShopAcitivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_shop_activities, :balance_amount, :decimal, precision: 11, scale: 3, default: 0, after: :total_income_amount, comment: "账户余额"
    add_column :report_shop_activities, :stage_1_balance_amount, :decimal, precision: 11, scale: 3, default: 0, after: :balance_amount, comment: "00:00-9:00 账户余额"
    add_column :report_shop_activities, :stage_2_balance_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_1_balance_amount, comment: "09:00-18:00 账户余额"
    add_column :report_shop_activities, :stage_3_balance_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_2_balance_amount, comment: "18:00-24:00 账户余额"
    add_column :report_shop_activities, :week_balance_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_3_balance_amount, comment: "本月账户余额"
    add_column :report_shop_activities, :month_balance_amount, :decimal, precision: 11, scale: 3, default: 0, after: :week_balance_amount, comment: "本周账户余额"
    add_column :report_shop_activities, :year_balance_amount, :decimal, precision: 11, scale: 3, default: 0, after: :month_balance_amount, comment: "本年账户余额"
    add_column :report_shop_activities, :total_balance_amount, :decimal, precision: 11, scale: 3, default: 0, after: :year_balance_amount, comment: "总账户余额"
  end
end
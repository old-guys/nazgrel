class AddWithdrawAmountToReportCumulativeShopActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :report_cumulative_shop_activities, :day_0_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :total_commission_income_amount, comment: "当天已提现金额"
    add_column :report_cumulative_shop_activities, :day_3_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :day_0_withdraw_amount, comment: "3天已提现金额"
    add_column :report_cumulative_shop_activities, :day_7_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :day_3_withdraw_amount, comment: "7天已提现金额"
    add_column :report_cumulative_shop_activities, :day_15_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :day_7_withdraw_amount, comment: "15天已提现金额"
    add_column :report_cumulative_shop_activities, :day_30_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :day_15_withdraw_amount, comment: "30天已提现金额"
    add_column :report_cumulative_shop_activities, :day_60_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, comment: "60天已提现金额"
    add_column :report_cumulative_shop_activities, :total_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :day_60_withdraw_amount, comment: "总已提现金额"
  end
end
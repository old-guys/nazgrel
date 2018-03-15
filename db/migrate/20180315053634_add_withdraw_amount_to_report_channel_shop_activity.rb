class AddWithdrawAmountToReportChannelShopActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :report_channel_shop_activities, :withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :total_commission_income_amount, comment: "已提现金额"
    add_column :report_channel_shop_activities, :stage_1_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :withdraw_amount, comment: "00:00-9:00 已提现金额"
    add_column :report_channel_shop_activities, :stage_2_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_1_withdraw_amount, comment: "09:00-18:00 已提现金额"
    add_column :report_channel_shop_activities, :stage_3_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_2_withdraw_amount, comment: "18:00-24:00 已提现金额"
    add_column :report_channel_shop_activities, :week_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_3_withdraw_amount, comment: "本月已提现金额"
    add_column :report_channel_shop_activities, :month_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :week_withdraw_amount, comment: "本周已提现金额"
    add_column :report_channel_shop_activities, :year_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :month_withdraw_amount, comment: "本年已提现金额"
    add_column :report_channel_shop_activities, :total_withdraw_amount, :decimal, precision: 11, scale: 3, default: 0, after: :year_withdraw_amount, comment: "总已提现金额"
  end
end
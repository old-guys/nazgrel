class AddCommissionIncomeAmountDescToReportChannelShopActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :report_channel_shop_activities, :commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :year_order_amount, comment: "店铺佣金"
    add_column :report_channel_shop_activities, :stage_1_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :commission_income_amount, comment: "00:00-9:00 店铺佣金"
    add_column :report_channel_shop_activities, :stage_2_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_1_commission_income_amount, comment: "09:00-18:00 店铺佣金"
    add_column :report_channel_shop_activities, :stage_3_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_2_commission_income_amount, comment: "18:00-24:00 店铺佣金"
    add_column :report_channel_shop_activities, :week_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_3_commission_income_amount, comment: "本月店铺佣金"
    add_column :report_channel_shop_activities, :month_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :week_commission_income_amount, comment: "本月店铺佣金"
    add_column :report_channel_shop_activities, :year_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :month_commission_income_amount, comment: "本年店铺佣金"
  end
end
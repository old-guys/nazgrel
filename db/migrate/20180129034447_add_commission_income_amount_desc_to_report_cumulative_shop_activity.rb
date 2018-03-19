class AddCommissionIncomeAmountDescToReportCumulativeShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_cumulative_shop_activities, :day_0_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :day_60_order_amount, comment: "当天店铺佣金"
    add_column :report_cumulative_shop_activities, :day_3_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :day_0_commission_income_amount, comment: "3天店铺佣金"
    add_column :report_cumulative_shop_activities, :day_7_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :day_3_commission_income_amount, comment: "7天店铺佣金"
    add_column :report_cumulative_shop_activities, :day_15_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :day_7_commission_income_amount, comment: "15天店铺佣金"
    add_column :report_cumulative_shop_activities, :day_30_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :day_15_commission_income_amount, comment: "30天店铺佣金"
    add_column :report_cumulative_shop_activities, :day_60_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, comment: "60天店铺佣金"
  end
end
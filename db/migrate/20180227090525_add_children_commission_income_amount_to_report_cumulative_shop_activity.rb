class AddChildrenCommissionIncomeAmountToReportCumulativeShopActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :report_cumulative_shop_activities, :day_0_children_commission_income_amount, :integer, default: 0, after: :total_children_count, comment: "当天邀请店铺佣金"
    add_column :report_cumulative_shop_activities, :day_3_children_commission_income_amount, :integer, default: 0, after: :day_0_children_commission_income_amount, comment: "3天邀请店铺佣金"
    add_column :report_cumulative_shop_activities, :day_7_children_commission_income_amount, :integer, default: 0, after: :day_3_children_commission_income_amount, comment: "7天邀请店铺佣金"
    add_column :report_cumulative_shop_activities, :day_15_children_commission_income_amount, :integer, default: 0, after: :day_7_children_commission_income_amount, comment: "15天邀请店铺佣金"
    add_column :report_cumulative_shop_activities, :day_30_children_commission_income_amount, :integer, default: 0, after: :day_15_children_commission_income_amount, comment: "30天邀请店铺佣金"
    add_column :report_cumulative_shop_activities, :day_60_children_commission_income_amount, :integer, default: 0, after: :day_30_children_commission_income_amount, comment: "60天邀请店铺佣金"
    add_column :report_cumulative_shop_activities, :total_children_commission_income_amount, :integer, default: 0, after: :day_60_children_commission_income_amount, comment: "总邀请店铺佣金"
  end
end
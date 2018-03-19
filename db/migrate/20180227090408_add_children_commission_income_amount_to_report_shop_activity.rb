class AddChildrenCommissionIncomeAmountToReportShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_shop_activities, :children_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :total_sale_order_amount, comment: "邀请店铺佣金"
    add_column :report_shop_activities, :stage_1_children_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :children_commission_income_amount, comment: "00:00-9:00 邀请店铺佣金"
    add_column :report_shop_activities, :stage_2_children_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_1_children_commission_income_amount, comment: "09:00-18:00 邀请店铺佣金"
    add_column :report_shop_activities, :stage_3_children_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_2_children_commission_income_amount, comment: "18:00-24:00 邀请店铺佣金"
    add_column :report_shop_activities, :week_children_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_3_children_commission_income_amount, comment: "本月邀请店铺佣金"
    add_column :report_shop_activities, :month_children_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :week_children_commission_income_amount, comment: "本月邀请店铺佣金"
    add_column :report_shop_activities, :year_children_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :month_children_commission_income_amount, comment: "本年邀请店铺佣金"
    add_column :report_shop_activities, :total_children_commission_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :year_children_commission_income_amount, comment: "总邀请店铺佣金"
  end
end
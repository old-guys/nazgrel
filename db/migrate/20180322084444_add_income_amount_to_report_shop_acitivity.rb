class AddIncomeAmountToReportShopAcitivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_shop_activities, :income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :total_order_amount, comment: "账户收入"
    add_column :report_shop_activities, :stage_1_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :income_amount, comment: "00:00-9:00 账户收入"
    add_column :report_shop_activities, :stage_2_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_1_income_amount, comment: "09:00-18:00 账户收入"
    add_column :report_shop_activities, :stage_3_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_2_income_amount, comment: "18:00-24:00 账户收入"
    add_column :report_shop_activities, :week_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :stage_3_income_amount, comment: "本月账户收入"
    add_column :report_shop_activities, :month_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :week_income_amount, comment: "本周账户收入"
    add_column :report_shop_activities, :year_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :month_income_amount, comment: "本年账户收入"
    add_column :report_shop_activities, :total_income_amount, :decimal, precision: 11, scale: 3, default: 0, after: :year_income_amount, comment: "总账户收入"
  end
end
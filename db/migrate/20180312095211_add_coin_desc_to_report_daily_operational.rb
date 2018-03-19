class AddCoinDescToReportDailyOperational < ActiveRecord::Migration[5.2]
  def change
    add_column :report_daily_operationals, :income_coin, :decimal, precision: 11, scale: 3, comment: "收入芝蚂币"
    add_column :report_daily_operationals, :use_coin, :decimal, precision: 11, scale: 3, comment: "已使用芝蚂币"
  end
end
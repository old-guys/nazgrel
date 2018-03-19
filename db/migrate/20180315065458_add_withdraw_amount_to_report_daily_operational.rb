class AddWithdrawAmountToReportDailyOperational < ActiveRecord::Migration[5.2]
  def change
    add_column :report_daily_operationals, :withdraw_amount, :decimal, precision: 11, scale: 3
  end
end

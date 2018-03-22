class AddBalanceCoinToReportShopAcitivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_shop_activities, :balance_coin, :decimal, precision: 11, scale: 3, default: 0, after: :total_use_coin, comment: "芝蚂币余额"
    add_column :report_shop_activities, :stage_1_balance_coin, :decimal, precision: 11, scale: 3, default: 0, after: :balance_coin, comment: "00:00-9:00 芝蚂币余额"
    add_column :report_shop_activities, :stage_2_balance_coin, :decimal, precision: 11, scale: 3, default: 0, after: :stage_1_balance_coin, comment: "09:00-18:00 芝蚂币余额"
    add_column :report_shop_activities, :stage_3_balance_coin, :decimal, precision: 11, scale: 3, default: 0, after: :stage_2_balance_coin, comment: "18:00-24:00 芝蚂币余额"
    add_column :report_shop_activities, :week_balance_coin, :decimal, precision: 11, scale: 3, default: 0, after: :stage_3_balance_coin, comment: "本月芝蚂币余额"
    add_column :report_shop_activities, :month_balance_coin, :decimal, precision: 11, scale: 3, default: 0, after: :week_balance_coin, comment: "本周芝蚂币余额"
    add_column :report_shop_activities, :year_balance_coin, :decimal, precision: 11, scale: 3, default: 0, after: :month_balance_coin, comment: "本年芝蚂币余额"
    add_column :report_shop_activities, :total_balance_coin, :decimal, precision: 11, scale: 3, default: 0, after: :year_balance_coin, comment: "总芝蚂币余额"
  end
end
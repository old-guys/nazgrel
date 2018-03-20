class AddUseCoinToReportChannelShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :report_channel_shop_activities, :use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :total_income_coin, comment: "使用芝蚂币"
    add_column :report_channel_shop_activities, :stage_1_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :use_coin, comment: "00:00-9:00 使用芝蚂币"
    add_column :report_channel_shop_activities, :stage_2_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :stage_1_use_coin, comment: "09:00-18:00 使用芝蚂币"
    add_column :report_channel_shop_activities, :stage_3_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :stage_2_use_coin, comment: "18:00-24:00 使用芝蚂币"
    add_column :report_channel_shop_activities, :week_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :stage_3_use_coin, comment: "本月使用芝蚂币"
    add_column :report_channel_shop_activities, :month_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :week_use_coin, comment: "本周使用芝蚂币"
    add_column :report_channel_shop_activities, :year_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :month_use_coin, comment: "本年使用芝蚂币"
    add_column :report_channel_shop_activities, :total_use_coin, :decimal, precision: 11, scale: 3, default: 0, after: :year_use_coin, comment: "总使用芝蚂币"
  end
end
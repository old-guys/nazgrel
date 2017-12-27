class AddDayGradeGoldToReportChannelShopNewer < ActiveRecord::Migration[5.1]
  def change
    add_column :report_channel_shop_newers, :day_grade_platinum, :integer, comment: "本月累计白金店主数"
    add_column :report_channel_shop_newers, :day_grade_gold, :integer, comment: "本月累计黄金店主数"
  end
end
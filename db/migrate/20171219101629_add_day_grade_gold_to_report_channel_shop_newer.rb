class AddDayGradeGoldToReportChannelShopNewer < ActiveRecord::Migration[5.1]
  def change
    add_column :report_channel_shop_newers, :day_grade_platinum, :integer
    add_column :report_channel_shop_newers, :day_grade_gold, :integer
  end
end

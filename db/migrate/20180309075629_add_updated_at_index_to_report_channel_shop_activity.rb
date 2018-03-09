class AddUpdatedAtIndexToReportChannelShopActivity < ActiveRecord::Migration[5.1]
  def change
    add_index :report_channel_shop_activities, :updated_at
  end
end
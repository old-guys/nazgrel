class AddUpdatedAtIndexToReportShopActivity < ActiveRecord::Migration[5.1]
  def change
    add_index :report_shop_activities, :updated_at
  end
end
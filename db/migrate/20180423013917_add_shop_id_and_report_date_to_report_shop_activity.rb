class AddShopIdAndReportDateToReportShopActivity < ActiveRecord::Migration[5.2]
  def change
    remove_index :report_shop_activities, [:report_date, :shop_id]

    add_index :report_shop_activities, [:shop_id, :report_date]
  end
end
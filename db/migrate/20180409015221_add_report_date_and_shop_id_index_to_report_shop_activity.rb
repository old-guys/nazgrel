class AddReportDateAndShopIdIndexToReportShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_index :report_shop_activities, [:report_date, :shop_id]
  end
end
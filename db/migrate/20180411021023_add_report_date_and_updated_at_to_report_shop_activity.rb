class AddReportDateAndUpdatedAtToReportShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_index :report_shop_activities, [:report_date, :updated_at]
  end
end
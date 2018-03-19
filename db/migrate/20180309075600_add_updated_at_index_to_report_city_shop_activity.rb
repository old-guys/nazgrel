class AddUpdatedAtIndexToReportCityShopActivity < ActiveRecord::Migration[5.2]
  def change
    add_index :report_city_shop_activities, :updated_at
  end
end
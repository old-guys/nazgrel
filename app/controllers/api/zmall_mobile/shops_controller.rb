class Api::ZmallMobile::ShopsController < Api::ZmallMobile::BaseController
  include ActionSearchable
  include ActionUtilable

  before_action :set_shop

  def summary
  end

  def stat
    @report_shop_activities = ReportShopActivity.limit_within_group(
      records: ReportShopActivity.where(
        report_date: 1.years.ago(Date.today)..Date.today,
        shop_id: @shop.id
      ),
      rating_name: 'DATE_FORMAT(report_date, "%Y-%M")',
      sort: "report_date desc",
      limit: 1
    )
  end

  private
  def set_shop
    @shop = Shop.find(params[:id])
  end
end
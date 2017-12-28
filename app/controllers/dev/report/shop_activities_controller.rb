class Dev::Report::ShopActivitiesController < Dev::Report::BaseController
  include ActionSearchable

  def index
    @report_shop_activities = ReportShopActivity.preload(shop: :shopkeeper).where(report_date: params[:report_date])

    @report_shop_activities = filter_by_pagination(relation: @report_shop_activities, default_per_page: 50)
  end
end
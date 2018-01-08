class Dev::Report::CityShopActivitiesController < Dev::Report::BaseController
  include ActionSearchable

  def index
    params[:report_date] ||= Date.today.to_s

    @report_city_shop_activities = ReportCityShopActivity.where(report_date: params[:report_date])

    @report_city_shop_activities = filter_by_pagination(relation: @report_city_shop_activities, default_per_page: 50)
  end
end
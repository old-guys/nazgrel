class Dev::Report::CityShopActivitiesController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    params[:report_date] ||= Date.today.to_s

    @report_city_shop_activities = ReportCityShopActivity.where(report_date: params[:report_date])
    preload_export(service: 'Dev::CityShopActivity', action: 'report', relation: @report_city_shop_activities)

    @report_city_shop_activities = filter_by_pagination(relation: @report_city_shop_activities)
  end
end
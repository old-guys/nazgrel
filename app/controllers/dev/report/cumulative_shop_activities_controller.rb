class Dev::Report::CumulativeShopActivitiesController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    @report_cumulative_shop_activities = ReportCumulativeShopActivity.preload(:shopkeeper, :shop)

    @report_cumulative_shop_activities = sort_records(relation: @report_cumulative_shop_activities, default_order: {report_date: :desc})

    preload_export(service: 'Dev::CumulativeShopActivity', action: 'report', relation: @report_cumulative_shop_activities)

    @report_cumulative_shop_activities = filter_by_pagination(relation: @report_cumulative_shop_activities, default_per_page: 50)
  end
end
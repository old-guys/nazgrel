class Dev::Report::OperationalCumulativeShopActivitySummariesController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    params[:report_date] ||= Date.today.all_week.to_s
    _dates = range_within_date(str: params[:report_date]) rescue Date.today.all_week

    @report_operational_cumulative_shop_activity_summaries = ReportOperationalCumulativeShopActivitySummary.where(report_date: _dates)
    preload_export(service: 'Dev::OperationalCumulativeShopActivitySummary', action: 'report', relation: @report_operational_cumulative_shop_activity_summaries)

    @report_operational_cumulative_shop_activity_summaries = filter_by_pagination(relation: @report_operational_cumulative_shop_activity_summaries)
  end
end
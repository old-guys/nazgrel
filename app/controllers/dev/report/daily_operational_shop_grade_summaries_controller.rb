class Dev::Report::DailyOperationalShopGradeSummariesController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    params[:report_date] ||= Date.today.all_week.to_s
    _dates = range_within_date(str: params[:report_date]) rescue Date.today.all_week

    @report_daily_operational_shop_grade_summaries = ReportDailyOperationalShopGradeSummary.where(report_date: _dates)
    preload_export(service: 'Dev::DailyOperationalShopGradeSummary', action: 'report', relation: @report_daily_operational_shop_grade_summaries)

    @report_daily_operational_shop_grade_summaries = filter_by_pagination(relation: @report_daily_operational_shop_grade_summaries)
  end
end
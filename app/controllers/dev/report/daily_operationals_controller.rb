class Dev::Report::DailyOperationalsController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    params[:report_date] ||= Date.today.all_week.to_s
    _dates = range_within_date(str: params[:report_date]) rescue Date.today.all_week

    @report_daily_operationals = ReportDailyOperational.where(report_date: _dates)
    preload_export(service: 'Dev::DailyOperational', action: 'report', relation: @report_daily_operationals)

    @report_daily_operationals = filter_by_pagination(relation: @report_daily_operationals)
  end
end
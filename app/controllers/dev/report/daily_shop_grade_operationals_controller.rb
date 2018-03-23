class Dev::Report::DailyShopGradeOperationalsController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    params[:report_date] ||= Date.today.all_week.to_s
    _dates = range_within_date(str: params[:report_date]) rescue Date.today.all_week

    @report_daily_shop_grade_operationals = ReportDailyShopGradeOperational.where(report_date: _dates)
    preload_export(service: 'Dev::DailyShopGradeOperational', action: 'report', relation: @report_daily_shop_grade_operationals)

    @report_daily_shop_grade_operationals = filter_by_pagination(relation: @report_daily_shop_grade_operationals)
  end
end
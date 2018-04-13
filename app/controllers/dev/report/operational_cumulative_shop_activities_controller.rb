class Dev::Report::OperationalCumulativeShopActivitiesController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    params[:stat_field] ||= "day_30_order_number"
    params[:stat_category] ||= "order_number"


    params[:created_at] ||= 1.months.ago..Time.now
    _datetimes = range_within_datetime(str: params[:created_at]) rescue Date.today.all_week

    @report_cumulative_shop_activities = ReportCumulativeShopActivity.joins(:shopkeeper).
      preload(:shopkeeper, :shop)

    @report_cumulative_shop_activities = @report_cumulative_shop_activities.where(
      shopkeepers: {created_at: _datetimes}
    )
    if params[:stat_field].present? and params[:value_must_lte].present?
      @report_cumulative_shop_activities = @report_cumulative_shop_activities.where(
        "`#{ReportCumulativeShopActivity.table_name}`.`#{params[:stat_field]}` >= ?", params[:value_must_lte]
      )
    end

    preload_export(
      service: 'Dev::OperationalCumulativeShopActivity',
      action: 'report',
      relation: @report_cumulative_shop_activities,
      stat_field: params[:stat_field],
      stat_category: params[:stat_category]
    )

    @report_cumulative_shop_activities = filter_by_pagination(relation: @report_cumulative_shop_activities)
  end
end
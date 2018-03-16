class Dev::Report::CumulativeShopActivitiesController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    _dates = range_within_datetime(str: params[:created_at]) rescue DateTime.now.all_day

    @report_cumulative_shop_activities = ReportCumulativeShopActivity.
      preload(:shopkeeper, :shop)

    _query = shopkeeper_params.select{|_,v| v.presence }
    if _query.present?
      _shopkeeper = Shopkeeper.find_by(_query)
      @report_cumulative_shop_activities = @report_cumulative_shop_activities.where(
        shop_id: _shopkeeper.try(:shop_id)
      )
    else
      @report_cumulative_shop_activities = @report_cumulative_shop_activities.joins(:shopkeeper).
        where(shopkeepers: {created_at: _dates})
    end

    @report_cumulative_shop_activities = sort_records(relation: @report_cumulative_shop_activities, default_order: {report_date: :desc})

    preload_export(service: 'Dev::CumulativeShopActivity', action: 'report', relation: @report_cumulative_shop_activities)

    @report_cumulative_shop_activities = filter_by_pagination(relation: @report_cumulative_shop_activities)
  end

  private
  def shopkeeper_params
    params.permit(
      :id,
      :user_id, :user_phone
    )
  end
end
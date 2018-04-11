class Api::OpenMobile::Report::CumulativeShopActivitiesController < Api::OpenMobile::BaseController
  include ActionSearchable

  def index
    @report_cumulative_shop_activities = ReportCumulativeShopActivity.all
    if params[:shop_id].present?
      @report_cumulative_shop_activities = @report_cumulative_shop_activities.where(shop_id: params[:shop_id])
    end

    dates = distance_time_range_from_now(
      str: params[:updated_at_range].presence,
    )
    if dates.present?
      @report_cumulative_shop_activities = @report_cumulative_shop_activities.where(updated_at: dates)
    end

    @report_cumulative_shop_activities = sort_records(relation: @report_cumulative_shop_activities, default_order:
      {updated_at: :desc, id: :desc}
    )
    @report_cumulative_shop_activities = filter_by_pagination(relation: @report_cumulative_shop_activities)
  end
end
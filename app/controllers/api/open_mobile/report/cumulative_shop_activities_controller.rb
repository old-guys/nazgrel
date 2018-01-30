class Api::OpenMobile::Report::CumulativeShopActivitiesController < Api::OpenMobile::BaseController
  include ActionSearchable

  def index
    @report_cumulative_shop_activities = ReportCumulativeShopActivity.all
    @report_cumulative_shop_activities = sort_records(relation: @report_cumulative_shop_activities)
    if params[:shop_id].present?
      @report_cumulative_shop_activities = @report_cumulative_shop_activities.where(shop_id: params[:shop_id])
    end

    @report_cumulative_shop_activities = filter_by_pagination(relation: @report_cumulative_shop_activities)
  end
end
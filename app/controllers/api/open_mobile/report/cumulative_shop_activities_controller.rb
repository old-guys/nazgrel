class Api::OpenMobile::Report::CumulativeShopActivitiesController < Api::OpenMobile::BaseController
  include ActionSearchable

  def index
    @report_cumulative_shop_activities = ReportCumulativeShopActivity.preload(:shopkeeper)
    @report_cumulative_shop_activities = sort_records(relation: @report_cumulative_shop_activities)

    @report_cumulative_shop_activities = filter_by_pagination(relation: @report_cumulative_shop_activities)
  end
end
class Api::OpenMobile::Report::ShopActivitiesController < Api::OpenMobile::BaseController
  include ActionSearchable

  def index
    _report_date = params[:report_date].presence || Date.today.to_s
    @report_shop_activities = ReportShopActivity.where(report_date: _report_date)
    if params[:shop_id].present?
      @report_shop_activities = @report_shop_activities.where(shop_id: params[:shop_id])
    end

    @report_shop_activities = sort_records(relation: @report_shop_activities)
    @report_shop_activities = filter_by_pagination(relation: @report_shop_activities)
  end
end
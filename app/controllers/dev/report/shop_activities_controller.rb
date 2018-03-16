class Dev::Report::ShopActivitiesController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    params[:report_date] ||= Date.today.to_s

    @report_shop_activities = ReportShopActivity.preload(shop: :shopkeeper).where(report_date: params[:report_date])

    if params[:shop_id].present?
      @report_shop_activities = @report_shop_activities.unscope(where: :report_date).where(shop_id: params[:shop_id])
    end

    preload_export(service: 'Dev::ShopActivity', action: 'report', relation: @report_shop_activities)

    @report_shop_activities = filter_by_pagination(relation: @report_shop_activities)
  end
end
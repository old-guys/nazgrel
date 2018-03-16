class Dev::Report::ShopsController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def index
    _dates = range_within_datetime(str: params[:created_at]) rescue DateTime.now.all_day

    @shops = Shop.preload(shopkeeper: [:parent, :report_cumulative_shop_activity]).where(created_at: _dates)

    preload_export(service: 'Dev::Shop', action: 'report', relation: @shops)

    @shops = filter_by_pagination(relation: @shops)
  end
end
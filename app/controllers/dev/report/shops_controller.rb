class Dev::Report::ShopsController < Dev::Report::BaseController
  include ActionSearchable

  def index
    _dates = range_within_datetime(str: params[:created_at]) rescue DateTime.now.all_day

    @shops = Shop.preload(shopkeeper: :parent).where(created_at: _dates)

    @shops = filter_by_pagination(relation: @shops, default_per_page: 50)
  end
end
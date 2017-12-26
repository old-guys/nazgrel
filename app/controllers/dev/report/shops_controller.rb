class Dev::Report::ShopsController < ApplicationController
  include ActionSearchable

  layout "dev"

  def index
    _dates = params[:created_at] ||= DateTime.now.all_day
    if params[:created_at].include?("..")
      _values = _dates.split("..")

      _dates = DateTime.parse(_values[0])..DateTime.parse(_values[1])
    else
      _dates = DateTime.parse(params[:created_at]).all_day
    end

    @shops = Shop.preload(shopkeeper: :parent).where(created_at: _dates)

    @shops = filter_by_pagination(relation: @shops, default_per_page: 50)
  end
end
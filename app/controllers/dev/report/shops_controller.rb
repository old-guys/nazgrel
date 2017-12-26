class Dev::Report::ShopsController < ApplicationController
  include ActionSearchable

  layout "dev"

  def index
    _dates = params[:created_at] ||= Date.today.to_s
    if _dates.include?("..")
      _values = _dates.split("..")

      _dates = Date.parse(_values[0])..Date.parse(_values[1])
    end

    @shops = Shop.preload(shopkeeper: :parent).where(created_at: _dates)

    @shops = filter_by_pagination(relation: @shops)
  end
end
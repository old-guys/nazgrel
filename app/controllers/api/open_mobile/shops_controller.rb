class Api::OpenMobile::ShopsController < Api::OpenMobile::BaseController
  include ActionSearchable

  def summary
    @shop = Shop.find(params[:id])
  end
end
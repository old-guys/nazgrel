class Api::Web::ShopkeepersController < Api::Web::BaseController

  def check
    @shopkeeper = Shopkeeper.find_by user_phone: params[:phone]
    @shopkeeper ||= Shopkeeper.find_by user_id: params[:user_id]

    raise Errors::RecordNotFoundError.new("找不到相应的店主") if @shopkeeper.blank?
  end
end
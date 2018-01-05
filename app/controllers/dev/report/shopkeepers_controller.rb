class Dev::Report::ShopkeepersController < Dev::Report::BaseController
  include ActionSearchable

  def tree
    _query = tree_params.select{|_,v| v.presence }
    @shopkeeper = Shopkeeper.find_by _query if _query.present?
  end

  private
  def tree_params
    params.permit(
      :id,
      :user_id, :user_phone
    )
  end
end
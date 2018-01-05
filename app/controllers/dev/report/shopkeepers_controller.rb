class Dev::Report::ShopkeepersController < Dev::Report::BaseController
  include ActionSearchable

  def tree
    @shopkeeper = Shopkeeper.find_by tree_params if tree_params.present?
  end

  private
  def tree_params
    params.permit(
      :id,
      :user_id, :user_phone
    )
  end
end
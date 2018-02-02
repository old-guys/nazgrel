class Dev::Report::ShopkeepersController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def tree
    _query = tree_params.select{|_,v| v.presence }
    if _query.present?
      @shopkeeper = Shopkeeper.find_by _query
      preload_export(service: 'Dev::Shopkeeper', action: 'tree', relation: Shopkeeper.where(_query), tree_depth: params[:tree_depth])
    end
  end

  private
  def tree_params
    params.permit(
      :id,
      :user_id, :user_phone
    )
  end
end
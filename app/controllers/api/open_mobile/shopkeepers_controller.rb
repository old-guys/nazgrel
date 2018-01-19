class Api::OpenMobile::ShopkeepersController < Api::OpenMobile::BaseController
  include ActionSearchable
  include Api::OpenMobile::ActionOwnable
  before_action :set_shopkeepers

  # order: "order_number desc" # "shopkeeper.commission_income_amount ASC"
  # query: "张三"
  def index
    @shopkeepers = @permit_shopkeepers.preload(:shop)
    if index_params[:user_grade].present?
      @shopkeepers = @shopkeepers.where(user_grade: Shopkeeper.user_grades[index_params[:user_grade]])
    end
    if index_params[:city].present?
      @shopkeepers = @shopkeepers.where(city: index_params[:city])
    end

    # @shopkeepers = filter_records_by(relation: @shopkeepers)
    @shopkeepers = simple_search(relation: @shopkeepers)
    @shopkeepers = sort_records(relation: @shopkeepers)
    @shopkeepers = filter_by_pagination(relation: @shopkeepers)
  end

  def sales
    @shopkeepers = @permit_shopkeepers.preload(:shop)
    if index_params[:user_grade].present?
      @shopkeepers = @shopkeepers.where(user_grade: Shopkeeper.user_grades[index_params[:user_grade]])
    end
    if index_params[:city].present?
      @shopkeepers = @shopkeepers.where(city: index_params[:city])
    end

    @shopkeepers = @shopkeepers.order("order_amount DESC")
    @shopkeepers = filter_by_pagination(relation: @shopkeepers)
  end

  def report
    @shopkeepers = Shopkeeper.preload(
      :shop, :parent,
      :shop_user
    )

    if params[:shop_id].present?
      @shopkeepers = @shopkeepers.where(shop_id: params[:shop_id])
    end

    @shopkeepers = filter_by_pagination(relation: @shopkeepers)
  end

  private
  def index_params
    params.permit(
      :user_grade, :city
    )
  end
  def sales_params
    params.permit(
      :user_grade, :city
    )
  end
end
class Api::OpenMobile::ShopkeepersController < Api::OpenMobile::BaseController
  include ActionSearchable
  include Api::OpenMobile::ActionOwnable
  before_action :set_shopkeepers, only: [:index, :sales]

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

    dates = distance_time_range_from_now(
      str: params[:updated_at_range].presence,
    )
    if dates.present?
      @shopkeepers = @shopkeepers.where(updated_at: dates)
    end

    # @shopkeepers = filter_records_by(relation: @shopkeepers)
    @shopkeepers = simple_search(relation: @shopkeepers)
    @shopkeepers = sort_records(relation: @shopkeepers, default_order: {created_at: :desc})
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

    dates = distance_time_range_from_now(
      str: params[:updated_at_range].presence,
    )
    if dates.present?
      @shopkeepers = @shopkeepers.where(updated_at: dates)
    end

    @shopkeepers = @shopkeepers.order("order_amount DESC")
    @shopkeepers = filter_by_pagination(relation: @shopkeepers)
  end

  def report
    @shopkeepers = Shopkeeper.preload(
      :shop, :parent, :report_cumulative_shop_activity,
      :shop_user
    )

    if params[:shop_id].present?
      @shopkeepers = @shopkeepers.where(shop_id: params[:shop_id])
    end

    dates = distance_time_range_from_now(
      str: params[:updated_at_range].presence,
    )
    if dates.present?
      @shopkeepers = @shopkeepers.where(updated_at: dates)
    end

    @shopkeepers = sort_records(relation: @shopkeepers, default_order: {id: :asc})

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
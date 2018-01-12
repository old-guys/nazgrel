class Dev::Report::OrdersController < Dev::Report::BaseController
  include ActionSearchable

  def index
    @orders = Order.preload(:order_details).sales_order.valided_order

    search_product_related_orders
    search_supplier_related_orders
    search_category_related_orders

    if params[:created_at].present?
      @orders = @orders.where(created_at: range_within_datetime(str: params[:created_at]))
    end

    @orders = filter_by_pagination(relation: @orders, default_per_page: 50)
  end

  def sales
    @dates = range_within_datetime(str: params[:created_at]) rescue DateTime.now.all_day

    @orders = Order.preload(
      order_subs: [
        :supplier,
        {order_details: [:product, :category]}
      ]
    ).sales_order.valided_order.where(created_at: @dates)

    @orders = filter_by_pagination(relation: @orders, default_per_page: 50)
  end

  private
  def search_product_related_orders
    return if params[:product_name].blank?

    product_ids = Product.simple_search(params[:product_name]).pluck(:id)
    @orders = @orders.joins(:products).where(
      products: {
        id: product_ids
      }
    )
  end

  def search_supplier_related_orders
    return if params[:supplier_id].blank?

    @orders = @orders.joins(
      :order_subs
    ).where(
      order_subs: {
        supplier_id: params[:supplier_id]
      }
    )
  end

  def search_category_related_orders
    return if params[:category_id].blank?

    @orders = @orders.joins(:products).where(
      products: {
        id: params[:category_id]
      }
    )
  end

end
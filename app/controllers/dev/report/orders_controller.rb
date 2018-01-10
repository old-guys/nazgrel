class Dev::Report::OrdersController < Dev::Report::BaseController
  include ActionSearchable

  def index
    @orders = Order.joins(:products, order_subs: [
        :supplier,
      ]
    ).sales_order.valided_order

    search_product_related_orders
    search_supplier_related_orders
    search_category_related_orders

    @orders = filter_by_pagination(relation: @orders, default_per_page: 50)
  end

  def sales
    @dates = range_within_datetime(str: params[:created_at]) rescue DateTime.now.all_day

    @orders = Order.preload(
      order_subs: [
        :supplier,
        {order_details: :product}
      ]
    ).sales_order.valided_order.where(created_at: @dates)

    @orders = filter_by_pagination(relation: @orders, default_per_page: 50)
  end

  private

  def search_product_related_orders
    return if params[:product_name].blank?

    product_ids = Product.simple_search(params[:product_name]).pluck(:id)
    @orders = @orders.where(products: { id: product_ids })
  end

  def search_supplier_related_orders
    return if params[:supplier_name].blank?

    supplier_ids = Supplier.simple_search(params[:supplier_name]).pluck(:id)
    @orders = @orders.where(suppliers: { id: supplier_ids })
  end

  def search_category_related_orders
    return if params[:category_name].blank?

    category_ids = Category.simple_search(params[:category_name]).pluck(:id)
    @orders = @orders.where(products: { id: category_ids })
  end

end
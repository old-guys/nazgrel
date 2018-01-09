class Dev::Report::OrdersController < Dev::Report::BaseController
  include ActionSearchable

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
end
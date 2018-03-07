class Dev::Report::OrderDetailsController < Dev::Report::BaseController
  include ActionSearchable
  include ActionExportable

  def sales
    _dates = range_within_datetime(str: params[:created_at]) rescue Date.today

    @all_order_details = OrderDetail.joins(:order).merge(
      Order.sales_order.valided_order.where(created_at: _dates)
    )

    @order_details = @all_order_details.group(:product_id).
      order("sum(`order_details`.`product_num` * `order_details`.`product_sale_price`) DESC")

    preload_export(service: 'Dev::OrderDetail', action: 'sales', relation: @order_details)

    @order_details = filter_by_pagination(relation: @order_details, default_per_page: 50)
  end

  private
end
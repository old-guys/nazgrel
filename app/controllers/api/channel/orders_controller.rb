class Api::Channel::OrdersController < Api::Channel::BaseController
  include ActionSearchable

  # filters: [{
  #   name: "created_at", field_type: "datetime",
  #   operator: "within", query: "today"
  # }]
  def index
    @orders = current_channel.orders.sales_order.order(created_at: :desc)

    @orders = filter_records_by(relation: @orders)
    @orders = filter_by_pagination(relation: @orders)
  end

  def awaiting_delivery
    @orders = current_channel.orders.sales_order.awaiting_delivery.order(created_at: :desc)

    @orders = filter_records_by(relation: @orders)
    @orders = filter_by_pagination(relation: @orders)
  end

  def refund
    @orders = current_channel.orders.sales_order.none.order(created_at: :desc)

    @orders = filter_records_by(relation: @orders)
    @orders = filter_by_pagination(relation: @orders)
  end

  def show
    @order = current_channel.orders.find(params[:id])
  end
end

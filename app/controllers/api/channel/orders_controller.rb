class Api::Channel::OrdersController < Api::Channel::BaseController
  include ActionSearchable

  # filters: [{
  #   name: "created_at", field_type: "datetime",
  #   operator: "within", query: "today"
  # }]
  # order: "total_price desc" # "created_at ASC"
  # query: "1011021365231191"
  def index
    @orders = current_channel_user.own_orders.sales_order

    @orders = filter_records_by(relation: @orders)
    @orders = simple_search(relation: @orders)
    @orders = sort_records(relation: @orders)
    @orders = filter_by_pagination(relation: @orders)
  end

  def awaiting_delivery
    @orders = current_channel_user.own_orders.sales_order.undelivered_than_hour

    @orders = filter_records_by(relation: @orders)
    @orders = simple_search(relation: @orders)
    @orders = sort_records(relation: @orders)
    @orders = filter_by_pagination(relation: @orders)
  end

  def refund
    @orders = current_channel_user.own_orders.sales_order.none

    @orders = filter_records_by(relation: @orders)
    @orders = simple_search(relation: @orders)
    @orders = sort_records(relation: @orders)
    @orders = filter_by_pagination(relation: @orders)
  end

  def show
    @order = current_channel_user.own_orders.find(params[:id])
  end
end
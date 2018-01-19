class Api::Channel::ShopsController < Api::Channel::BaseController
  include ActionSearchable
  include Api::Channel::ActionOwnable

  # filters: [{
  #   name: "created_at", field_type: "datetime",
  #   operator: "within", query: "today"
  # }]
  # order: "order_number desc" # "shopkeeper.commission_income_amount ASC"
  # query: "张三"
  def index
    @shops = own_record_by_channel_user(klass: Shop).preload(
      shopkeeper: :parent
    ).joins(:shopkeeper)

    @shops = filter_records_by(relation: @shops)
    @shops = simple_search(relation: @shops)
    @shops = sort_records(relation: @shops)
    @shops = filter_by_pagination(relation: @shops)
  end

  def sales
    @shops = own_record_by_channel_user(klass: Shop).preload(:shopkeeper).joins(:shopkeeper)
    @channel_user = current_channel_user

    @shops = filter_records_by(relation: @shops)
    @shops = simple_search(relation: @shops)
    @shops = sort_records(relation: @shops)
    @shops = filter_by_pagination(relation: @shops)
  end

  def children
    @shop = current_channel_user.own_shops.find(params[:id])

    @shops = @shop.children
  end

  def show
    @shop = current_channel_user.own_shops.find(params[:id])
  end
end
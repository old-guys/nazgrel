class Api::Channel::ShopsController < Api::Channel::BaseController
  include ActionSearchable

  # filters: [{
  #   name: "created_at", field_type: "datetime",
  #   operator: "within", query: "today"
  # }]
  def index
    @shops = current_channel_user.own_shops.preload(:shopkeeper).order(created_at: :desc)

    @shops = filter_records_by(relation: @shops)
    @shops = filter_by_pagination(relation: @shops)
  end

  def sales
    @shops = current_channel_user.own_shops.preload(:shopkeeper).order(created_at: :desc)
    @channel_user = current_channel_user

    @shops = filter_records_by(relation: @shops)
    @shops = filter_by_pagination(relation: @shops)
  end

  def show
    @shop = current_channel_user.own_shops.find(params[:id])
  end
end

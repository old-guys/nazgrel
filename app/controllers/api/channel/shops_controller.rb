class Api::Channel::ShopsController < Api::Channel::BaseController
  include ActionSearchable

  # filters: [{
  #   name: "created_at", field_type: "datetime",
  #   operator: "within", query: "today"
  # }]
  def index
    @shops = current_channel.descendant_shops

    @shops = filter_records_by(relation: @shops)
    @shops = filter_by_pagination(relation: @shops)
  end

  def show
    @shop = current_channel.self_and_descendant_shops.find(params[:id])
  end
end

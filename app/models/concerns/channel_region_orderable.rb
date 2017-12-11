module ChannelRegionOrderable
  extend ActiveSupport::Concern

  included do
  end

  def orders
    Order.where(shop_id: shops.select(:id))
  end

  def root_orders
    Order.where(shop_id: root_shops.select(:id))
  end

  module ClassMethods
  end
end
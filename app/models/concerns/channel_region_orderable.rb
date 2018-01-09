module ChannelRegionOrderable
  extend ActiveSupport::Concern

  included do
  end

  def orders
    Order.where(shop_id: shop_ids)
  end

  def root_orders
    Order.where(shop_id: root_shop_ids)
  end

  module ClassMethods
  end
end
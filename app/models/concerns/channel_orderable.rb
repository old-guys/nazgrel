module ChannelOrderable
  extend ActiveSupport::Concern

  included do
  end

  def self_orders
    Order.where(shop_id: shop_id)
  end

  def self_and_descendant_orders
    Order.where(shop_id: self_and_descendant_shops.select(:id))
  end
  alias :orders :self_and_descendant_orders

  def descendant_orders
    Order.where(shop_id: descendant_shops.select(:id))
  end

  module ClassMethods
  end
end

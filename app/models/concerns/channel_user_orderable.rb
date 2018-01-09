module ChannelUserOrderable
  extend ActiveSupport::Concern

  included do
  end

  def self_and_descendant_orders
    Order.where(shop_id: shop_ids)
  end
  alias :orders :self_and_descendant_orders

  module ClassMethods
  end
end
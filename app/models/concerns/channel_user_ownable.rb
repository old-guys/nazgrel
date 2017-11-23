module ChannelUserOwnable
  extend ActiveSupport::Concern

  included do
  end

  def own_shops
    all_own? ? channel.shops : shops
  end

  def own_shopkeepers
    all_own? ? channel.shopkeepers : shopkeepers
  end

  def own_orders
    all_own? ? channel.orders : orders
  end

  module ClassMethods
  end
end

module ChannelUserOwnable
  extend ActiveSupport::Concern

  included do
  end

  def own_shops
    case role_type.to_sym
      when :normal_user
        shops
      when :manager
        channel.shops
      when :region_manager
        region_manager? ? channel_region.shops : Shop.none
    end
  end

  def own_shopkeepers
    case role_type.to_sym
      when :normal_user
        shopkeepers
      when :manager
        channel.shopkeepers
      when :region_manager
        region_manager? ? channel_region.shopkeepers : Shopkeeper.none
    end
  end

  def own_orders
    case role_type.to_sym
      when :normal_user
        orders
      when :manager
        channel.orders
      when :region_manager
        region_manager? ? channel_region.orders : Order.none
    end
  end

  module ClassMethods
  end
end

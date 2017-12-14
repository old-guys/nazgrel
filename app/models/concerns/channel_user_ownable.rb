module ChannelUserOwnable
  extend ActiveSupport::Concern

  included do
  end

  def all_own_for(klass, channel: nil, channel_only: false)
    case klass.name
      when "Shop"
        own_shops(channel: channel)
      when "Shopkeeper"
        own_shopkeepers(channel: channel)
      when "Order"
        own_orders(channel: channel)
      when "Product"
        own_products(channel: channel)
      when "OrderDetail"
        own_order_details(channel: channel)
      else
        klass.none
    end
  end


  def own_shops(channel: nil, channel_only: false)
    if role_type.to_sym == :region_manager and channel.is_a?(Channel)
      return channel.try(:shops)
    end
    if role_type.to_sym == :region_manager and channel_only
      return channel_region.try(:root_shops)
    end

    case role_type.to_sym
      when :normal_user
        shops
      when :manager
        self.channel.shops
      when :region_manager
        channel_region.try(:shops) || Shop.none
    end
  end

  def own_shopkeepers(channel: nil, channel_only: false)
    if role_type.to_sym == :region_manager and channel.is_a?(Channel)
      return channel.try(:shopkeepers)
    end
    if role_type.to_sym == :region_manager and channel_only
      return channel_region.try(:root_shopkeepers)
    end

    case role_type.to_sym
      when :normal_user
        shopkeepers
      when :manager
        self.channel.shopkeepers
      when :region_manager
        channel_region.try(:shopkeepers) || Shopkeeper.none
    end
  end

  def own_orders(channel: nil, channel_only: false)
    if role_type.to_sym == :region_manager and channel.is_a?(Channel)
      return channel.try(:orders)
    end
    if role_type.to_sym == :region_manager and channel_only
      return channel_region.try(:root_orders)
    end

    case role_type.to_sym
      when :normal_user
        orders
      when :manager
        self.channel.orders
      when :region_manager
        channel_region.try(:orders) || Order.none
    end
  end

  def own_products(channel: nil, channel_only: false)
    if role_type.to_sym == :region_manager and channel.is_a?(Channel)
      return channel.try(:products)
    end
    if role_type.to_sym == :region_manager and channel_only
      return channel_region.try(:root_products)
    end

    case role_type.to_sym
      when :normal_user
        products
      when :manager
        self.channel.products
      when :region_manager
        channel_region.try(:products) || Product.none
    end
  end

  def own_order_details(channel: nil, channel_only: false)
    OrderDetail.joins(:order).where(
      orders: {
        order_no: own_orders(
          channel: channel, channel_only: channel_only
        ).select(:order_no)
      }
    )
  end

  module ClassMethods
  end
end
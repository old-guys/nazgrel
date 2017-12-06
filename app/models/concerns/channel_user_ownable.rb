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
        channel_region.try(:shops) || Shop.none
    end
  end

  def own_shopkeepers
    case role_type.to_sym
      when :normal_user
        shopkeepers
      when :manager
        channel.shopkeepers
      when :region_manager
        channel_region.try(:shopkeepers) || Shopkeeper.none
    end
  end

  def own_orders
    case role_type.to_sym
      when :normal_user
        orders
      when :manager
        channel.orders
      when :region_manager
        channel_region.try(:orders) || Order.none
    end
  end

  def own_products
    case role_type.to_sym
      when :normal_user
        products
      when :manager
        channel.products
      when :region_manager
        channel_region.try(:products) || Product.none
    end
  end

  module ClassMethods
  end
end

module ChannelUserStatusable
  extend ActiveSupport::Concern

  included do
  end

  def shop_count
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:shop_count:raw", raw: true, expires_in: 3.minutes) {
      own_shops.size
    }.to_i
  end

  def order_count
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:order_count:raw", raw: true, expires_in: 3.minutes) {
      own_shopkeepers.sum(:order_number)
    }.to_i
  end

  def total_order_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:order_total_price:raw", raw: true, expires_in: 3.minutes) {
      own_shopkeepers.sum(:order_amount)
    }
  end

  def today_shop_count
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:today_shop_count:raw", raw: true, expires_in: 3.minutes) {
      own_shops.where(created_at: Time.now.all_day).size
    }.to_i
  end

  def today_order_count
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:today_order_count:raw", raw: true, expires_in: 3.minutes) {
      own_orders.where(created_at: Time.now.all_day).sales_order.valided_order.size
    }.to_i
  end

  def today_hot_sales_product
    _data = Rails.cache.fetch("channel_user:#{id}:#{role_type}:today_hot_sales_product:raw", raw: true, expires_in: 3.minutes) {
      result = own_order_details.hot_sales_product(times: Time.now.all_day)
      _products = Product.where(id: result.pluck(:product_id))

      result = result.map {|h|
        _product = _products.find {|product| product.id == h[:product_id]}
        next if _product.blank?

        {
          product_num: h[:total_product_num],
          product_name: _product.to_s,
          product_id: h[:product_id]
        }
      }.compact

      result = result.map.with_index(1){|h, index|
        h.merge(index: index)
      }

      result.to_yaml
    }

    YAML.load(_data)
  end

  def commission_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:commissiont:raw", raw: true, expires_in: 3.minutes) {
      own_orders.sales_order.valided_order.sum(:comm)
    }.to_i
  end

  def invite_children_reward_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:invite_children_reward:raw", raw: true, expires_in: 3.minutes) {
      if region_manager?
        channel_region.channels.map(&:invite_children_reward_amount).sum
      else
        own_shopkeeper.children.grade_platinum.size * 200 + own_shopkeeper.children.grade_platinum.size * 100
      end
    }
  end

  def children_comission_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:children_comission:raw", raw: true, expires_in: 3.minutes) {
      if region_manager?
        channel_region.channels.map(&:children_comission_amount).sum
      else
        Order.where(shop_id: own_shop.children.select(:id)).sales_order.valided_order.sum(:comm) * 0.15
      end
    }
  end

  def invite_children_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:invite_amount:raw", raw: true, expires_in: 3.minutes) {
      if region_manager?
        channel_region.channels.map(&:invite_children_amount).sum
      else
        own_shopkeeper.children.size * BigDecimal.new(50)
      end
    }
  end

  def indirectly_descendant_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:indirectly_descendant_comission:raw", raw: true, expires_in: 3.minutes) {
      if region_manager?
        channel_region.channels.map(&:indirectly_descendant_amount).sum
      else
        _rate = own_shop.indirectly_descendants.size > 1000 ? 0.08 : 0.05
        _amount = Order.where(shop_id: own_shop.indirectly_descendants.select(:id)).sales_order.valided_order.sum(:comm)
        _amount * _rate
      end
    }
  end

  module ClassMethods
  end
end
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
      own_orders.sales_order.valided_order.size
    }.to_i
  end

  def total_order_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:order_total_price:raw", raw: true, expires_in: 3.minutes) {
      Order.where(shop_id: own_shopkeepers.select(:shop_id)).sales_order.valided_order.sum(:total_price)
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

  def commission_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:commissiont:raw", raw: true, expires_in: 3.minutes) {
      Order.where(user_id: own_shopkeepers.select(:user_id)).sales_order.valided_order.sum(:comm)
    }.to_i
  end

  def invite_children_reward_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:invite_children_reward:raw", raw: true, expires_in: 3.minutes) {
      own_shopkeeper.children.grade_platinum.size * 200 + own_shopkeeper.children.grade_platinum.size * 100
    }
  end

  def children_comission_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:children_comission:raw", raw: true, expires_in: 3.minutes) {
      Order.where(user_id: own_shopkeeper.children.select(:user_id)).sales_order.valided_order.sum(:comm) * 0.15
    }
  end

  def invite_children_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:invite_amount:raw", raw: true, expires_in: 3.minutes) {
      own_shopkeeper.children.size * BigDecimal.new(50)
    }
  end

  def indirectly_descendant_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:indirectly_descendant_comission:raw", raw: true, expires_in: 3.minutes) {
      _rate = own_shopkeeper.indirectly_descendants.size > 1000 ? 0.08 : 0.05
      _amount = Order.where(user_id: own_shopkeeper.indirectly_descendants.select(:user_id)).sales_order.valided_order.sum(:comm)
      _amount * _rate
    }
  end

  module ClassMethods
  end
end

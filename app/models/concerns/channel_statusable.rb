module ChannelStatusable
  extend ActiveSupport::Concern

  included do
  end

  def shop_count
    Rails.cache.fetch("channel:#{id}:shop_count:raw", raw: true, expires_in: 3.minutes) {
      shops.size
    }.to_i
  end

  def order_count
    Rails.cache.fetch("channel:#{id}:order_count:raw", raw: true, expires_in: 3.minutes) {
      shopkeepers.sum(:order_number)
    }.to_i
  end

  def total_order_amount
    Rails.cache.fetch("channel:#{id}:order_total_price:raw", raw: true, expires_in: 3.minutes) {
      shopkeepers.sum(:order_amount)
    }
  end

  def today_shop_count
    Rails.cache.fetch("channel:#{id}:today_shop_count:raw", raw: true, expires_in: 3.minutes) {
      shops.where(created_at: Time.now.all_day).size
    }.to_i
  end

  def today_order_count
    Rails.cache.fetch("channel:#{id}:today_order_count:raw", raw: true, expires_in: 3.minutes) {
      orders.where(created_at: Time.now.all_day).sales_order.valided_order.size
    }.to_i
  end

  def commission_amount
    Rails.cache.fetch("channel:#{id}:commissiont:raw", raw: true, expires_in: 3.minutes) {
      orders.sales_order.valided_order.sum(:comm)
    }.to_i
  end

  def invite_children_reward_amount
    Rails.cache.fetch("channel:#{id}:invite_children_reward:raw", raw: true, expires_in: 3.minutes) {
      own_shopkeeper.children_grade_gold_size * 200 + own_shopkeeper.children_grade_platinum_size * 100
    }
  end

  def children_comission_amount
    Rails.cache.fetch("channel:#{id}:children_comission:raw", raw: true, expires_in: 3.minutes) {
      Order.where(shop_id: own_shop.children.select(:id)).sales_order.valided_order.sum(:comm) * 0.15
    }
  end

  def invite_children_amount
    Rails.cache.fetch("channel:#{id}:invite_amount:raw", raw: true, expires_in: 3.minutes) {
      own_shopkeeper.children_size * BigDecimal.new(50)
    }
  end

  def indirectly_descendant_amount
    Rails.cache.fetch("channel:#{id}:indirectly_descendant_comission:raw", raw: true, expires_in: 3.minutes) {
      _rate = own_shop.indirectly_descendants.size > 1000 ? 0.08 : 0.05
      _amount = Order.where(shop_id: own_shop.indirectly_descendants.select(:id)).sales_order.valided_order.sum(:comm)
      _amount * _rate
    }
  end

  module ClassMethods
  end
end
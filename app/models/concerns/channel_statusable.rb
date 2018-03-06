module ChannelStatusable
  extend ActiveSupport::Concern

  included do
  end

  def shopkeepers_cache_key
    @shopkeepers_cache_key ||= shopkeepers.cache_key
  end

  def shop_count
    Rails.cache.fetch("channel:#{id}:#{shopkeepers_cache_key}:shop_count:raw") {
      shopkeepers.size
    }.to_i
  end

  def order_count
    Rails.cache.fetch("channel:#{id}:#{shopkeepers_cache_key}:order_count:raw", raw: true) {
      shopkeepers.sum(:order_number)
    }.to_i
  end

  def total_order_amount
    Rails.cache.fetch("channel:#{id}:#{shopkeepers_cache_key}:order_total_price:raw", raw: true) {
      shopkeepers.sum(:order_amount)
    }
  end

  def today_shop_count
    Rails.cache.fetch("channel:#{id}:#{shopkeepers_cache_key}:today_shop_count:raw", raw: true) {
      shops.where(created_at: Time.now.all_day).size
    }.to_i
  end

  def today_order_count
    Rails.cache.fetch("channel:#{id}:#{shopkeepers_cache_key}:today_order_count:raw", raw: true) {
      orders.where(created_at: Time.now.all_day).sales_order.valided_order.size
    }.to_i
  end

  def commission_amount_cache_key
    "channel:#{id}:commissiont:raw"
  end

  def commission_amount
    Rails.cache.fetch(commission_amount_cache_key, raw: true) {
      shopkeepers.sum(:commission_income_amount)
    }
  end

  def invite_children_reward_amount
    own_shopkeeper.invite_amount
  end

  def children_comission_amount
    own_shopkeeper.children_commission_income_amount * 0.15
  end

  def invite_children_amount
    own_shopkeeper.children_size * BigDecimal.new(50)
  end

  def indirectly_descendant_amount
    _rate = own_shopkeeper.indirectly_descendant_size > 1000 ? 0.08 : 0.05
    own_shopkeeper.indirectly_descendant_commission_income_amount * _rate
  end

  module ClassMethods
  end
end
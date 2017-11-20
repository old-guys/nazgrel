module ChannelShopStatusable
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
      orders.size
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
      orders.where(created_at: Time.now.all_day).size
    }.to_i
  end

  def commission_amount
    Rails.cache.fetch("channel:#{id}:commissiont:raw", raw: true, expires_in: 3.minutes) {
      IncomeRecord.where(user_id: shopkeepers.select(:user_id)).commission_income.sum(:income_amount)
    }.to_i
  end

  def invite_children_reward_amount
    Rails.cache.fetch("channel:#{id}:invite_children_reward:raw", raw: true, expires_in: 3.minutes) {
      own_shopkeeper.children.grade_platinum.size * 200 + own_shopkeeper.children.grade_platinum.size * 100
    }
  end

  def children_comission_amount
    Rails.cache.fetch("channel:#{id}:children_comission:raw", raw: true, expires_in: 3.minutes) {
      IncomeRecord.where(user_id: own_shopkeeper.children.select(:user_id)).commission_income.sum(:income_amount) * 0.15
    }
  end

  def invite_children_amount
    Rails.cache.fetch("channel:#{id}:invite_amount:raw", raw: true, expires_in: 3.minutes) {
      own_shopkeeper.children.size * BigDecimal.new(50)
    }
  end

  def indirectly_descendant_amount
    Rails.cache.fetch("channel:#{id}:indirectly_descendant_comission:raw", raw: true, expires_in: 3.minutes) {
      _rate = own_shopkeeper.indirectly_descendants.size > 1000 ? 0.08 : 0.05
      _amount = IncomeRecord.where(user_id: own_shopkeeper.indirectly_descendants.select(:user_id)).commission_income.sum(:income_amount)
      _amount * _rate
    }
  end

  module ClassMethods
  end
end

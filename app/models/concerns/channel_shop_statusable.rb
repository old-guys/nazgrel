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

  module ClassMethods
  end
end

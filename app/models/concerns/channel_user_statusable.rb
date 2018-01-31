module ChannelUserStatusable
  extend ActiveSupport::Concern

  included do
    include RecordCacheable
  end

  def own_shopkeepers_cache_key
    @own_shopkeepers_cache_key ||= own_shopkeepers.cache_key
  end

  def shop_count
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:shop_count:raw", raw: true) {
      own_shopkeepers.size
    }.to_i
  end

  def order_count
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:order_count:raw", raw: true) {
      own_shopkeepers.sum(:order_number)
    }.to_i
  end

  def total_order_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:order_total_price:raw", raw: true) {
      own_shopkeepers.sum(:order_amount)
    }
  end

  def today_shop_count
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:today_shop_count:raw", raw: true) {
      own_shopkeepers.where(created_at: Time.now.all_day).size
    }.to_i
  end

  def today_order_count
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:today_order_count:raw", raw: true) {
      own_orders.where(created_at: Time.now.all_day).sales_order.valided_order.size
    }.to_i
  end

  def today_hot_sales_product
    _data = Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:today_hot_sales_product:raw", raw: true) {
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
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:commissiont:raw", raw: true) {
      own_shopkeepers.sum(:commission_income_amount)
    }.to_i
  end

  def invite_children_reward_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:invite_children_reward:raw", raw: true) {
      if region_manager?
        fetch_multi(
          records: channel_region.channels.preload(:own_shopkeeper),
          cache_key: :invite_children_reward_amount_cache_key,
          raw: true
        ) {|record|
          record.invite_children_reward_amount
        }.values.map(&:to_f).sum.to_s
      else
        own_shopkeeper.children_grade_gold_size * 200 + own_shopkeeper.children_grade_platinum_size * 100
      end
    }
  end

  def children_comission_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:children_comission:raw", raw: true) {
      if region_manager?
        fetch_multi(
          records: channel_region.channels.preload(:own_shopkeeper),
          cache_key: :children_comission_amount_cache_key,
          raw: true
        ) {|record|
          record.children_comission_amount
        }.values.map(&:to_f).sum.to_s
      else
        own_shopkeeper.children.sum(:commission_income_amount) * 0.15
      end
    }
  end

  def invite_children_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:invite_amount:raw", raw: true) {
      if region_manager?
        fetch_multi(
          records: channel_region.channels.preload(:own_shopkeeper),
          cache_key: :invite_children_amount_cache_key,
          raw: true
        ) {|record|
          record.invite_children_amount
        }.values.map(&:to_f).sum.to_s
      else
        own_shopkeeper.children_size * BigDecimal.new(50)
      end
    }
  end

  def indirectly_descendant_amount
    Rails.cache.fetch("channel_user:#{id}:#{role_type}:#{own_shopkeepers_cache_key}:indirectly_descendant_comission:raw", raw: true) {
      if region_manager?
        fetch_multi(
          records: channel_region.channels.preload(:own_shopkeeper),
          cache_key: :indirectly_descendant_amount_cache_key,
          raw: true
        ) {|record|
          record.indirectly_descendant_amount
        }.values.map(&:to_f).sum.to_s
      else
        _rate = own_shopkeeper.indirectly_descendant_size > 1000 ? 0.08 : 0.05
        _amount = own_shopkeeper.indirectly_descendants.sum(:commission_income_amount)
        _amount * _rate
      end
    }
  end

  module ClassMethods
  end
end
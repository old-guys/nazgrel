module ChannelRegionShopable
  extend ActiveSupport::Concern

  included do
    has_many :root_shops, through: :channels, source: "own_shop"
  end

  def shops
    @shops ||= proc {
      Rails.cache.fetch("#{cache_key}:shops:#{channels.cache_key}") {
        real_shops.all
      }
    }.call
  end

  def shop_ids
    @shop_ids ||= shops.pluck(:id)
  end

  def real_shops
    @real_shops ||= proc {
      _channels = channels.preload(:own_shop).to_a

      _shops = _channels.shift.shops
      _channels.each {|channel|
        _shops = _shops.or(channel.shops)
      }

      _shops
    }.call
  end

  module ClassMethods
  end
end
module ChannelRegionShopable
  extend ActiveSupport::Concern

  included do
    has_many :root_shops, through: :channels, source: "own_shop"
    has_many :own_shops, through: :channels, source: :own_shops
  end

  def shops
    Rails.cache.fetch("shops:#{cache_key}:#{channel_channel_region_maps.cache_key}") {
      Shop.where(id: shop_ids)
    }
  end

  def shop_ids
    Rails.cache.fetch("shop_ids:#{cache_key}:#{channel_channel_region_maps.cache_key}") {
      own_shop_ids
    }
  end

  module ClassMethods
  end
end
module ChannelRegionShopable
  extend ActiveSupport::Concern

  included do
    has_many :root_shops, through: :channels, source: "own_shop"

    has_many :own_shops, through: :channels, source: :own_shops
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

      Shop.where(
        _channels.map{|channel|
          Utility.where_sql_str(channel.shops)
        }.join(" OR ")
      )
    }.call
  end

  module ClassMethods
  end
end
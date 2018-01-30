module ChannelRegionShopable
  extend ActiveSupport::Concern

  included do
    has_many :root_shops, through: :channels, source: "own_shop"
    has_many :own_shops, through: :channels, source: :own_shops

    alias :shops :own_shops
    alias :shop_ids :own_shop_ids
  end

  module ClassMethods
  end
end
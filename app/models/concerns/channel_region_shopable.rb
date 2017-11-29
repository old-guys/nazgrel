module ChannelRegionShopable
  extend ActiveSupport::Concern

  included do
    has_many :root_shops, through: :channels, source: "own_shop"
  end

  def shops
    _channels = channels.to_a

    if _channels.length == 1
      _channels[0].shops
    else
      _shops = _channels.shift.shops
      _channels.each {|channel|
        _shops = _shops.or(channel.shops)
      }
      _shops
    end
  end

  module ClassMethods
  end
end

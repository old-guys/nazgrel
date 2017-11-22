module ChannelShopable
  extend ActiveSupport::Concern

  included do
    has_many :root_shops, through: :channel_users, source: "own_shop"
  end

  def shops
    _root_shops = root_shops.to_a

    if _root_shops.length == 1
      Shop.self_and_descendant_entities(_root_shops[0], column: :channel_path)
    else
      _shops = Shop.self_and_descendant_entities(_root_shops.shift, column: :channel_path)
      _root_shops.each {|shop|
        _shops = _shops.or(Shop.self_and_descendant_entities(shop, column: :channel_path))
      }
      _shops
    end
  end

  module ClassMethods
  end
end

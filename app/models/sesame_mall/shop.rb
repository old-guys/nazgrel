class Shop < ApplicationRecord
  has_one :shopkeeper

  has_one :channel

  has_many :orders
  has_many :income_records, through: :shopkeeper

  has_many :product_shops
  has_many :products, through: :product_shops

  include TreeDescendantable
  include ShopProductable

  def to_s
    name || id.to_s
  end

  def ancestor_shopkeepers
    @_shopes ||= Shopkeeper.where(user_id: shopkeeper.path.to_s.split("/"))
  end

  def set_path
    self.path = shopkeeper.parents.map(&:shop_id).unshift(0).join("/")
  end

  def set_channel_path
    _user_ids = shopkeeper.path.to_s.split("/")
    _channels = Channel.where(shopkeeper_user_id: _user_ids).pluck_s(:id, :shopkeeper_user_id)
    _shop_ids = []

    shopkeeper.parents.each{|shopkeeper|
      _shop_ids << shopkeeper.shop_id

      if _channels.find{|s| s.shopkeeper_user_id.to_s == user_id}
        break
      end
    }
    _shop_ids.unshift("0")

    self.channel_path = _shop_ids.join("/")
  end
end

class Shop < ApplicationRecord
  has_one :shopkeeper
  has_one :shop_user, through: :shopkeeper

  has_one :channel

  has_many :orders
  has_many :income_records, through: :shopkeeper

  has_many :product_shops
  has_many :products, through: :product_shops

  include TreeDescendantable
  include ShopProductable
  include Searchable

  simple_search_on fields: [
    :name,
    "shopkeepers.user_name",
    "shopkeepers.user_phone"
  ], joins: :shopkeeper

  def to_s
    name || id.to_s
  end

  def shop_img_url
    "http://zmcimg.ishanggang.com/static/img/#{shop_img}"
  end

  def ancestor_shopkeepers
    @ancestor_shopkeepers ||= Shopkeeper.where(user_id: shopkeeper.path.to_s.split("/"))
  end

  def set_path
    self.path = shopkeeper.parents.map(&:shop_id).unshift(0).join("/")
  end

  def set_channel_path
    _channels = Channel.where(shopkeeper_user_id: shopkeeper.parent_ids).pluck_s(:id, :shop_id)
    _shop_ids = []

    shopkeeper.parents.reverse.each{|shopkeeper|
      _shop_ids << shopkeeper.shop_id
      _channel = _channels.find{|s| s.shop_id.to_s == shopkeeper.shop_id.to_s }

      if _channel.present?
        self.channel_id = _channel.id

        break
      end
    }
    _shop_ids.reverse!
    _shop_ids.unshift("0")

    self.channel_path = _shop_ids.join("/")
  end
end
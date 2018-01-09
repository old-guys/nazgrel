module ChannelUserShopable
  extend ActiveSupport::Concern

  included do
    belongs_to :own_shop, class_name: "Shop",
      foreign_key: :shop_id, required: false

    belongs_to :own_shopkeeper, class_name: "Shopkeeper",
      foreign_key: :shopkeeper_user_id, primary_key: :user_id, required: false
  end

  def self_and_descendant_shops
    @self_and_descendant_shops ||= Shop.self_and_descendant_entities(own_shop, column: :channel_path)
  end
  alias :shops :self_and_descendant_shops

  def shop_ids
    @shop_ids ||= shops.pluck(:id)
  end

  def descendant_shops
    Shop.where(id: shop_ids.reject{|id| id == own_shop.id })
  end

  def descendant_shop_ids
    @descendant_shops_ids ||= shop_ids.reject{|id| id == own_shop.id }
  end

  module ClassMethods
  end
end
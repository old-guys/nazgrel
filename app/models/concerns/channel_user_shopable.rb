module ChannelUserShopable
  extend ActiveSupport::Concern

  included do
    belongs_to :own_shop, class_name: "Shop",
      foreign_key: :shop_id, required: false

    belongs_to :own_shopkeeper, class_name: "Shopkeeper",
      foreign_key: :shopkeeper_user_id, primary_key: :user_id, required: false
  end

  def shops
    Shop.self_and_descendant_entities(own_shop, column: :channel_path)
  end

  def shop_ids
    @shop_ids ||= shops.loaded? ? shops.map(&:id) : shops.pluck(:id)
  end

  module ClassMethods
  end
end
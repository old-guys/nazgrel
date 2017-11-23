module ChannelUserShopable
  extend ActiveSupport::Concern

  included do
    belongs_to :own_shop, class_name: "Shop",
      foreign_key: :shop_id, required: false

    belongs_to :own_shopkeeper, class_name: "Shopkeeper",
      foreign_key: :shopkeeper_user_id, primary_key: :user_id, required: false
  end

  def self_and_descendant_shops
    Shop.self_and_descendant_entities(own_shop, column: :channel_path)
  end
  alias :shops :self_and_descendant_shops

  def descendant_shops
    Shop.descendant_entities(own_shop, column: :channel_path)
  end

  module ClassMethods
  end
end

module ChannelShopable
  extend ActiveSupport::Concern

  included do
    belongs_to :own_shop, class_name: "Shop",
      foreign_key: :shop_id, required: false

    belongs_to :own_shopkeeper, class_name: "Shopkeeper",
      foreign_key: :shopkeeper_user_id, required: false
  end

  def self_and_descendant_shops
    own_shop.try(:self_and_descendant_entities)
  end
  alias :shops :self_and_descendant_shops

  def descendant_shops
    own_shop.try(:descendant_entities)
  end

  module ClassMethods
  end
end

module ChannelUserShopkeeperable
  extend ActiveSupport::Concern

  included do
  end

  def self_and_descendant_shopkeepers
    Shopkeeper.where(shop_id: shop_ids)
  end
  alias :shopkeepers :self_and_descendant_shopkeepers

  def descendant_shopkeepers
    Shopkeeper.where(shop_id: descendant_shop_ids)
  end

  module ClassMethods
  end
end
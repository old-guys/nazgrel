module ChannelShopkeeperable
  extend ActiveSupport::Concern

  included do

  end

  def self_and_descendant_shopkeepers
    Shopkeeper.where(shop_id: self_and_descendant_shops.select(:id))
  end
  alias :shopkeepers :self_and_descendant_shopkeepers

  def descendant_shopkeepers
    Shopkeeper.where(shop_id: descendant_shops.select(:id))
  end

  module ClassMethods
  end
end

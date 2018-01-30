module ChannelUserShopkeeperable
  extend ActiveSupport::Concern

  included do
  end

  def shopkeepers
    Shopkeeper.where(shop_id: shop_ids)
  end

  module ClassMethods
  end
end
module ChannelShopkeeperable
  extend ActiveSupport::Concern

  included do
    has_many :root_shopkeepers, through: :root_shops, source: :shopkeeper
  end

  def shopkeepers
    Shopkeeper.where(shop_id: shop_ids)
  end

  module ClassMethods
  end
end
module ChannelRegionShopkeeperable
  extend ActiveSupport::Concern

  included do
    has_many :root_shopkeepers, through: :root_shops, source: :shopkeeper
  end

  def shopkeepers
    Shopkeeper.where(shop_id: shops.select(:id))
  end

  module ClassMethods
  end
end

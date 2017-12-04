module ChannelRegionProductable
  extend ActiveSupport::Concern

  included do
  end

  def products
    Product.joins(:product_shops).where(product_shops: {shop_id: shops.select(:id)})
  end

  module ClassMethods
  end
end

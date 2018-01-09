module ChannelUserProductable
  extend ActiveSupport::Concern

  included do
  end

  def products
    Product.joins(:product_shops).where(product_shops: {shop_id: shop_ids})
  end

  module ClassMethods
  end
end
module ChannelOrderable
  extend ActiveSupport::Concern

  included do
  end

  def orders
    Order.where(shop_id: shop_ids)
  end

  module ClassMethods
  end
end
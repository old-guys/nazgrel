module SesameMall::ShopKeeperTimestampable
  extend ActiveSupport::Concern

  included do
  end

  def touch_shopkeeper_timestamp(shopkeepers: , target: )
    shopkeepers.each {|shopkeeper|
      SesameMall::ShopkeeperSeekTimestampService.touch_timestamp(
        shopkeeper: shopkeeper,
        target: target
      )
    }
  end

  module ClassMethods
  end
end
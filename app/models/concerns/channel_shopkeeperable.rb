module ChannelShopkeeperable
  extend ActiveSupport::Concern

  included do
    has_many :root_shopkeepers, through: :root_shops, source: :shopkeeper
    has_many :own_shopkeepers, through: :own_shops, source: :shopkeeper

    alias :shopkeepers :own_shopkeepers
  end

  module ClassMethods
  end
end
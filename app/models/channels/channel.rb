class Channel < ApplicationRecord
  has_one :channel_user

  enum categroy: {
    seed_shopkeeper: 0,
    first_agent: 1,
    channel_manager: 2
  }
  enum source: {
    always: 0,
    weichaishi: 1,
    other: 2
  }

  include ChannelShopable
  include ChannelShopStatusable
  include ChannelOrderable
  include ChannelShopkeeperable
end
